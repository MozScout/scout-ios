//
//  PlayerService.swift
//  Scout
//
//

import Foundation
import AVFoundation

class PlayerService: NSObject {

    // MARK: - Private properties

    private var player: AVAudioPlayer?

    // MARK: - Public properties

    public var onDidFinishPlaying: (() -> Void)?

    public var currentTime: TimeInterval {
        return player?.currentTime ?? 0
    }

    public var isPlaying: Bool {
        return player?.isPlaying ?? false
    }

    public var url: URL? {
        return player?.url
    }

    // MARK: - Public methods

    func setAudio(from url: URL?) {
        if let url = url {
            player = createAudioPlayer(with: url)
        } else {
            player = nil
        }
    }

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    // MARK: - Private methods

    private func createAudioPlayer(with url: URL) -> AVAudioPlayer? {
        let player = try? AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.numberOfLoops = 1
        player?.prepareToPlay()
        return player
    }
}

extension PlayerService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onDidFinishPlaying?()
    }
}
