//
//  SpeechRecognizer.swift
//  Scout
//
//

import Foundation

enum SpeechRecognizerResult {

    case success(intent: Intent)
    case failure
}

protocol SpeechRecognizer: class {

    typealias Result = SpeechRecognizerResult

    var onResult: ((Result) -> Void)? { get set }
    var isListening: Bool { get }

    func startListening()
}
