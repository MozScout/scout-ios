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

    private let snips: SnipsPlatform
    private let audioProvider: AudioDataProvider
    private var listenSession: String?
    private var intent: Intent?

    init(audioProvider: AudioDataProvider) {
        self.audioProvider = audioProvider

        guard let url = Bundle.main.url(forResource: "assistant", withExtension: nil) else {
            fatalError("Cannot find snips assistant")
        }

        guard let snips = try? SnipsPlatform(assistantURL: url) else {
            fatalError("Cannot init snips")
        }

        self.snips = snips

        snips.onHotwordDetected = { [weak self] in
            self?.onDetect?()
        }
        
        snips.snipsWatchHandler = { log in
            print(log)
        }

        snips.onSessionStartedHandler = { [weak self] message in
            guard let strongSelf = self else { return }

            guard !strongSelf.isDetecting else {
                try! strongSelf.snips.endSession(message: EndSessionMessage(sessionId: message.sessionId))
                return
            }

            strongSelf.listenSession = message.sessionId
            strongSelf.intent = nil
        }

        snips.onSessionEndedHandler = { [weak self] message in
            guard let strongSelf = self else { return }

            guard strongSelf.listenSession == message.sessionId else { return }

            strongSelf.isListening = false
            strongSelf.listenSession = nil
            try! snips.pause()
            strongSelf.audioProvider.deactivate(strongSelf)

            if let intent = self?.intent {
                strongSelf.onResult?(.success(intent: intent))
            } else {
                strongSelf.onResult?(.failure)
            }
        }

        snips.onIntentDetected = { [weak self] message in
            self?.intent = Intent(message: message)
            try! self?.snips.endSession(sessionId: message.sessionId)
        }

        try! snips.start()
        try! snips.pause()

        audioProvider.addObserver(self)
    }
}

extension SnipsWrapper: HotwordDetector {

    func startDetecting() {
        isDetecting = true
        audioProvider.activate(self)
        try! snips.unpause()
    }

    func stopDetecting() {
        isDetecting = false
        try! snips.pause()
        audioProvider.deactivate(self)
    }
}

extension SnipsWrapper: SpeechRecognizer {

    func startListening() {
        guard !isDetecting else { return }

        isListening = true
        audioProvider.activate(self)
        try! snips.unpause()
        try! snips.startSession(message: StartSessionMessage(initType: SessionInitType.action(text: nil, intentFilter: nil, canBeEnqueued: false, sendIntentNotRecognized: true)))
    }
}

extension SnipsWrapper: AudioDataProviderObserver {

    func appendBuffer(_ buffer: AVAudioPCMBuffer, time: AVAudioTime) {
        DispatchQueue.main.async {
            try! self.snips.appendBuffer(buffer)
        }
    }
}
