//
//  SpeechService.swift
//  Scout
//
//

import Async
import Foundation
import Speech
import UIKit

enum SpeechMode {
    case disabled
    case hotword
    case recognition
}

class SpeechService: NSObject, SpeechServiceProtocol, SFSpeechRecognizerDelegate {
    let RESOURCE = Bundle.main.path(forResource: "common", ofType: "res")
    let MODEL = Bundle.main.path(forResource: "jarvis", ofType: "umdl")

    public weak var delegate: SBSpeechRecognizerDelegate?

    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    private var recognitionTask: SFSpeechRecognitionTask?

    private var audioEngine = AVAudioEngine()

    private var snowboyWrapper: SnowboyWrapper!
    private var dingSound: AVAudioPlayer!
    private var dongSound: AVAudioPlayer!
    private var speechMode: SpeechMode = .disabled

    init?(with locale: Locale) {
        guard let requiredRecognizer = SFSpeechRecognizer(locale: locale) else { return nil }
        self.speechRecognizer = requiredRecognizer
        self.audioEngine = AVAudioEngine()

        self.snowboyWrapper = SnowboyWrapper(resources: RESOURCE, modelStr: MODEL)
        self.snowboyWrapper.setSensitivity("0.8,0.80")
        self.snowboyWrapper.setAudioGain(1.0)
        self.snowboyWrapper.applyFrontend(true)

        do {
            self.dingSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "ding",
                                                                                                 ofType: "wav")!))
            self.dongSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "dong",
                                                                                                 ofType: "wav")!))
        } catch {
            print("Failed to load sounds: \(error)")
        }

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
            self.speechMode = .recognition
            speechRecognitionTimeout?.invalidate()

            speechRecognitionTimeout = Timer.scheduledTimer(timeInterval: speechTimeoutInterval,
                                                            target: self,
                                                            selector: #selector(timedOut),
                                                            userInfo: nil,
                                                            repeats: false)
        }
    }

    func startRecording() {
        if self.speechMode == .recognition {
            return
        }

        self.speechMode = .recognition
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
            if self.speechMode == .hotword {
                return
            }

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
                self.stopRecording()
                self.dongSound.play()
                self.delegate?.speechRecognitionFinished(transcription: result!.bestTranscription.formattedString)
            } else if error == nil {
                self.restartSpeechTimeout()
            } else {
                self.stopRecording()
                self.dongSound.play()
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0,
                             bufferSize: 1024,
                             format: recordingFormat) { (buffer: AVAudioPCMBuffer, _: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        self.dingSound.play()
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Failed to start audioEngine: \(error)")
        }
    }

    @objc private func timedOut() {
        if self.speechMode == .recognition {
            stopRecording()
        }
    }

    func stopRecording() {
        self.speechMode = .disabled
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0) // Remove tap on bus when stopping recording.

        recognitionRequest?.endAudio()

        speechRecognitionTimeout?.invalidate()
        speechRecognitionTimeout = nil
    }

    func beginWakeWordDetector() {
        if self.speechMode == .hotword {
            return
        }

        self.speechMode = .hotword
        let inputFormat = audioEngine.inputNode.outputFormat(forBus: 1)
        let recordingFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                            sampleRate: 16000.0,
                                            channels: 1,
                                            interleaved: false)!
        let converter = AVAudioConverter(from: inputFormat, to: recordingFormat)
        let seconds = 2.0
        let bufferSize = AVAudioFrameCount(inputFormat.sampleRate * seconds)
        audioEngine.inputNode.installTap(
            onBus: 1,
            bufferSize: bufferSize,
            format: inputFormat) { (buffer: AVAudioPCMBuffer, _: AVAudioTime) in
            let target = AVAudioPCMBuffer(pcmFormat: recordingFormat,
                                          frameCapacity: AVAudioFrameCount(recordingFormat.sampleRate * seconds))!
            var error: NSError?
            converter?.convert(to: target, error: &error, withInputFrom: { (_, outStatus) -> AVAudioBuffer? in
                outStatus.pointee = AVAudioConverterInputStatus.haveData
                return buffer
            })
            let array = Array(UnsafeBufferPointer(start: target.floatChannelData![0], count: Int(target.frameLength)))
            let result = self.snowboyWrapper.runDetection(array, length: Int32(buffer.frameLength))
            if result > 0 && self.speechMode == .hotword {
                self.endWakeWordDetector()
                self.delegate?.wakeWordDetected()
            }
        }
        do {
            try audioEngine.start()
        } catch {
            print("Failed to start audioEngine: \(error)")
        }
    }

    func endWakeWordDetector() {
        self.speechMode = .disabled
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 1)
    }
}
