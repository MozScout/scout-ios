//
//  SpeechService.swift
//  Scout
//
//

import Async
import Foundation
import Speech

import Speech
import UIKit

class SpeechService: NSObject, SpeechServiceProtocol, SFSpeechRecognizerDelegate {

    public weak var delegate: SBSpeechRecognizerDelegate?

    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    private var recognitionTask: SFSpeechRecognitionTask?

    private var audioEngine = AVAudioEngine()

    init?(with locale: Locale) {

        guard let requiredRecognizer = SFSpeechRecognizer(locale: locale) else { return nil }
        self.speechRecognizer = requiredRecognizer
        self.audioEngine = AVAudioEngine()

        super.init()

        self.speechRecognizer.delegate = self
    }

    private var speechRecognitionTimeout: Timer?

    var speechTimeoutInterval: TimeInterval = 2 {
        didSet {
            restartSpeechTimeout()
        }
    }

    private func restartSpeechTimeout() {
        if speechTimeoutInterval != 0 {
            speechRecognitionTimeout?.invalidate()

            speechRecognitionTimeout = Timer.scheduledTimer(timeInterval: speechTimeoutInterval,
                                                            target: self,
                                                            selector: #selector(timedOut),
                                                            userInfo: nil,
                                                            repeats: false)
        }
    }

    func startRecording() {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.audioEngine.stop()
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.recognitionTask = nil
            self.recognitionRequest = nil
            self.recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {}

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object")
        }

        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true

        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            if let result = result {
                isFinal = result.isFinal
                self.delegate?.speechRecognitionPartialResult(transcription: result.bestTranscription.formattedString)
            }

            if error != nil {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil
            }

            if isFinal {
                self.delegate?.speechRecognitionFinished(transcription: result!.bestTranscription.formattedString)
                self.stopRecording()
            } else {
                if error == nil {
                    self.restartSpeechTimeout()
                } else {
                    // cancel voice recognition
                }
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0,
                             bufferSize: 1024,
                             format: recordingFormat) { (buffer: AVAudioPCMBuffer, _: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {}
    }

    @objc private func timedOut() {
        stopRecording()
    }

    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0) // Remove tap on bus when stopping recording.

        recognitionRequest?.endAudio()

        speechRecognitionTimeout?.invalidate()
        speechRecognitionTimeout = nil
    }
}
