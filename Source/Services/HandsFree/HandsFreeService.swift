//
//  HandsFreeService.swift
//  Scout
//
//

import Foundation

class HandsFreeService {

    var detectionTimeout: TimeInterval
    private var timeoutTimer: Timer?

    var onHotwordDetect: (() -> Void)?
    var onIntentRecognize: ((Intent?) -> Void)?
    private(set) var isDetecting = false
    private let hotwordDetector: HotwordDetector
    private let speechRecognizer: SpeechRecognizer

    init(detectionTimeout: TimeInterval, hotwordDetector: HotwordDetector, speechRecognizer: SpeechRecognizer) {
        self.detectionTimeout = detectionTimeout
        self.hotwordDetector = hotwordDetector
        self.speechRecognizer = speechRecognizer

        self.hotwordDetector.onDetect = { [weak self] in
            self?.onHotwordDetect?()
            self?.hotwordDetector.stopDetecting()
            self?.speechRecognizer.startListening()
        }

        self.speechRecognizer.onResult = { [weak self] result in
            switch result {
            case .success(let intent):
                self?.onIntentRecognize?(intent)
            case .failure:
                self?.onIntentRecognize?(nil)
            }
            self?.hotwordDetector.startDetecting()
        }
    }

    func startDetecting() {
        hotwordDetector.startDetecting()
        isDetecting = true
        startTimeoutTimer()
    }

    func stopDetecting() {
        hotwordDetector.stopDetecting()
        isDetecting = false
        stopTimeoutTimer()
    }
}

private extension HandsFreeService {

    func startTimeoutTimer() {
        timeoutTimer?.invalidate()
        DispatchQueue.main.async {
            self.timeoutTimer = Timer.scheduledTimer(withTimeInterval: self.detectionTimeout, repeats: false, block: { [weak self] (_) in
                self?.stopDetecting()
            })
        }
    }

    func stopTimeoutTimer() {
        timeoutTimer?.invalidate()
        timeoutTimer = nil
    }
}
