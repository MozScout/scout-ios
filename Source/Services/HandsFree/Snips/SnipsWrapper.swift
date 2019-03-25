//
//  SnipsWrapper.swift
//  Scout
//
//

import Foundation
import AVFoundation
import SnipsPlatform

class SnipsWrapper {

    var onDetect: (() -> Void)?
    var onResult: ((SpeechRecognizer.Result) -> Void)?

    var isDetecting = false
    var isListening = false

    private var snips: SnipsPlatform?
    private let audioProvider: AudioDataProvider
    private var listenSession: String?
    private var intent: Intent?

    init(audioProvider: AudioDataProvider) {
        self.audioProvider = audioProvider

        audioProvider.addObserver(self)
    }
}

private extension SnipsWrapper {
    func startSnips() {
        audioProvider.activate(self)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else { return }

            guard let url = Bundle.main.url(forResource: "assistant", withExtension: nil) else {
                fatalError("Cannot find snips assistant")
            }

            guard let snips = try? SnipsPlatform(assistantURL: url) else {
                fatalError("Cannot init snips")
            }


            snips.onHotwordDetected = {
                DispatchQueue.main.async {
                    self?.onDetect?()
                }
            }

            snips.snipsWatchHandler = { log in
                DispatchQueue.main.async {
                    print(log)
                }
            }

            snips.onSessionStartedHandler = { message in
                guard let strongSelf = self else { return }

                guard !strongSelf.isDetecting else {
                    try! strongSelf.snips?.endSession(message: EndSessionMessage(sessionId: message.sessionId))
                    return
                }

                strongSelf.listenSession = message.sessionId
                strongSelf.intent = nil
            }

            snips.onSessionEndedHandler = { message in
                guard let strongSelf = self else { return }

                guard strongSelf.listenSession == message.sessionId else { return }

                strongSelf.isListening = false
                strongSelf.listenSession = nil
                strongSelf.stopSnips()

                DispatchQueue.main.async {
                    if let intent = strongSelf.intent {
                        strongSelf.onResult?(.success(intent: intent))
                    } else {
                        strongSelf.onResult?(.failure)
                    }
                }
            }

            snips.onIntentDetected = { message in
                self?.intent = Intent(message: message)
                try! self?.snips?.endSession(sessionId: message.sessionId)
            }

            snips.onIntentNotRecognizedHandler = { message in
                try! self?.snips?.endSession(sessionId: message.sessionId)
            }

            try! snips.start()
            if strongSelf.isListening {
                try! snips.startSession(
                    message: StartSessionMessage(
                        initType: SessionInitType.action(
                            text: nil,
                            intentFilter: nil,
                            canBeEnqueued: false,
                            sendIntentNotRecognized: true
                        )
                    )
                )
            }

            strongSelf.snips = snips
        }
    }

    func stopSnips() {
        snips = nil
        audioProvider.deactivate(self)
    }
}

extension SnipsWrapper: HotwordDetector {

    func startDetecting() {
        isDetecting = true
        startSnips()
    }

    func stopDetecting() {
        isDetecting = false
        stopSnips()
    }
}

extension SnipsWrapper: SpeechRecognizer {

    func startListening() {
        guard !isDetecting else { return }

        isListening = true
        startSnips()
    }
}

extension SnipsWrapper: AudioDataProviderObserver {

    func appendBuffer(_ buffer: AVAudioPCMBuffer, time: AVAudioTime) {
        try! self.snips?.appendBuffer(buffer)
    }
}
