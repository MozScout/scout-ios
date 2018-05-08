//
//  SpeechService.swift
//  Scout
//
//

import Foundation
import Speech
import Async

class SpeechService: NSObject {
    
    weak var delegate: SpeechServiceDelegate?
    
    fileprivate let recognizer: SFSpeechRecognizer
    fileprivate var recognitionTask: SFSpeechRecognitionTask?
    fileprivate var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    fileprivate let audioEngine: AVAudioEngine
    fileprivate var finalRecognizedText: String = ""
    
    init?(with locale: Locale) {
     
        guard let requiredRecognizer = SFSpeechRecognizer(locale: locale) else { return nil }
        self.recognizer = requiredRecognizer
        self.audioEngine = AVAudioEngine()
        
        super.init()
        
        self.recognizer.delegate = self
    }
}

// MARK: -
// MARK: SpeechServiceProtocol
extension SpeechService: SpeechServiceProtocol {
    
    func authorizeSpeechRecognition() {
        
        SFSpeechRecognizer.requestAuthorization { [weak self] (authorizationStatus) in
        
            guard let strongSelf = self,
                  let requiredDelegate = strongSelf.delegate
            else { return }
            
            Async.main({
                
                switch authorizationStatus {
                case .authorized:    requiredDelegate.speechService(strongSelf, didReceiveAuthorizationStatus: .authorized)
                case .denied:        requiredDelegate.speechService(strongSelf, didReceiveAuthorizationStatus: .denied)
                case .restricted:    requiredDelegate.speechService(strongSelf, didReceiveAuthorizationStatus: .denied)
                case .notDetermined: strongSelf.authorizeSpeechRecognition()
                }
            })
        }
    }
    
    func startRecording() {
        
        if let requiredRecognitionTask = self.recognitionTask {
            requiredRecognitionTask.cancel()
            self.recognitionTask = nil
        }

        guard self.recognizer.isAvailable else {
            print("SpeechService | StartRecording Failed -> recognizer is unavailable")
            return
        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        }
        catch let error {
            print("SpeechService | StartRecording Failed -> \(error.localizedDescription)")
            return
        }
        
        guard let requiredRecognitionRequest = recognitionRequest else {
            print("SpeechService | StartRecording Failed -> Unable to created a SFSpeechAudioBufferRecognitionRequest object")
            return
        }

        requiredRecognitionRequest.shouldReportPartialResults = true
        self.recognitionTask = self.recognizer.recognitionTask(with: requiredRecognitionRequest, delegate: self)
        
        let recordingFormat = self.audioEngine.inputNode.outputFormat(forBus: 0)
        self.audioEngine.inputNode.installTap(onBus: 0,
                                         bufferSize: 1024,
                                             format: recordingFormat) { [weak self] (buffer: AVAudioPCMBuffer, _) in
                                                
                                                guard let strongSelf = self,
                                                      let requiredRecognitionRequest = strongSelf.recognitionRequest
                                                else { return }

                                                requiredRecognitionRequest.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        }
        catch let error {
            print("SpeechService | StartRecording Failed -> \(error.localizedDescription)")
            return
        }
    }
    
    func stopRecording() {
        
        self.audioEngine.stop()
        self.audioEngine.inputNode.removeTap(onBus: 0)
        
        if let requiredRecognitionRequest = self.recognitionRequest {
            requiredRecognitionRequest.endAudio()
            self.recognitionRequest = nil
        }
        
        if let requiredRecognitionTask = self.recognitionTask {
            
            requiredRecognitionTask.finish()
            self.recognitionTask = nil
        }
    }
}

// MARK: -
// MARK: SFSpeechRecognizerDelegate
extension SpeechService: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
        guard let ruquiredDelegate = self.delegate else { return }
        ruquiredDelegate.speechService(self, recognitionAvailabilityDidChange: available)
    }
}

// MARK: -
// MARK: SFSpeechRecognitionTaskDelegate
extension SpeechService: SFSpeechRecognitionTaskDelegate {
    
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didHypothesizeTranscription transcription: SFTranscription) {
        
        guard let requiredDelegate = self.delegate else { return }
        requiredDelegate.speechService(self, didRecognizePartialResult: transcription.formattedString)
    }
    
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
        
        self.finalRecognizedText = recognitionResult.bestTranscription.formattedString
    }
    
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishSuccessfully successfully: Bool) {

        guard let requiredDelegate = self.delegate else { return }
        
        let result: SpeechServiceFinalRecognitionResult
        
        if successfully {
            result = .success(text: self.finalRecognizedText)
        }
        else {
            result = .failure(reason: task.error.debugDescription)
        }
        
        requiredDelegate.speechService(self, didFinishRecognitionWithResult: result)
    }
}

