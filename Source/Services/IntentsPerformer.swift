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

    private let playerCoordinator: PlayerCoordinator
    private var playerPreviosState: PlayerCoordinator.PlayerState = .paused

    init(handsFreeService: HandsFreeService, playerCoordinator: PlayerCoordinator) {
        self.playerCoordinator = playerCoordinator

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
            self?.playerPreviosState = self?.playerCoordinator.playerState ?? .paused
            self?.playerCoordinator.pause()
            print("___________________________________________________DETECT___________________________________________________")
            self?.dingSound.play()
        }

        handsFreeService.onIntentRecognize = { [weak self] intent in
            print("___________________________________________________INTENT___________________________________________________")
            self?.dongSound.play()
            switch self?.playerPreviosState ?? .paused {
            case .playing:
                self?.playerCoordinator.play()
            case .paused:
                break
            }

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

        switch intent {
        case .volumeUp(let value):
            DispatchQueue.main.async {
                self.playerCoordinator.volumeUp(by: value)
            }
        case .volumeDown(let value):
            DispatchQueue.main.async {
                self.playerCoordinator.volumeDown(by: value)
            }
        case .play:
            playerCoordinator.play()
        case .pause:
            playerCoordinator.pause()
        }
    }
}
