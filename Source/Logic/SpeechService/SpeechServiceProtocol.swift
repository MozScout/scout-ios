//
//  SpeechServiceProtocol.swift
//  Scout
//
//

import Foundation

enum SpeechServiceAuthorizationStatus {
    case authorized
    case denied
}

enum SpeechServiceFinalRecognitionResult {
    case success(text: String)
    case failure(reason: String)
}

protocol SpeechServiceProtocol {
    func beginWakeWordDetector()
    func endWakeWordDetector()
    func startRecording()
    func stopRecording()
    func speak(_ text: String, callback: (() -> Void)?)
}

protocol SBSpeechRecognizerDelegate: class {
    func speechRecognitionFinished(transcription: String)
    func speechRecognitionPartialResult(transcription: String)
    func wakeWordDetected()
}
