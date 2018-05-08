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
    
    func authorizeSpeechRecognition()
    func startRecording()
    func stopRecording()
}

protocol SpeechServiceDelegate: class {
    
    
    func speechService(_ service: SpeechService, didReceiveAuthorizationStatus status: SpeechServiceAuthorizationStatus)
    func speechService(_ service: SpeechService, recognitionAvailabilityDidChange available: Bool)
    
    func speechService(_ service: SpeechService, didFinishRecognitionWithResult result: SpeechServiceFinalRecognitionResult)
    func speechService(_ service: SpeechService, didRecognizePartialResult partialText: String)
}
