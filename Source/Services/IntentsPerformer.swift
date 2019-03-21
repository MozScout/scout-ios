//
//  IntentsPerformer.swift
//  Scout
//
//

import Foundation
import AVFoundation

class IntentPerformer {

    private var dingSound: AVAudioPlayer!
    private var dongSound: AVAudioPlayer!

    init(handsFreeService: HandsFreeService) {

        do {
            self.dingSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "ding",
                                                                                                 ofType: "wav")!))
            self.dongSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "dong",
                                                                                                 ofType: "wav")!))
        } catch {
            print("Failed to load sounds: \(error)")
        }

        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth, .allowBluetoothA2DP])
        try! audioSession.setPreferredSampleRate(16_000)
        try! audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        handsFreeService.onHotwordDetect = { [weak self] in
            print("___________________________________________________DETECT___________________________________________________")
            self?.dingSound.play()
        }

        handsFreeService.onIntentRecognize = { [weak self] intent in
            print("___________________________________________________INTENT___________________________________________________")
            self?.dongSound.play()

            if let intent = intent {
                self?.performIntent(intent)
            }
        }
    }

    func performIntent(_ intent: Intent) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dingSound.play()
            self.dongSound.play()
        }

        print(intent)
    }
}
