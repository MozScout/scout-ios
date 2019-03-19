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
    private var displayLink: CADisplayLink?

    // MARK: - Public properties

    public var onDidFinishPlaying: (() -> Void)?
    public var onPlaying: ((_ currentTime: TimeInterval?, _ duration: TimeInterval?) -> Void)?

    public var currentTime: TimeInterval? {
        return player?.currentTime
    }

    public var duration: TimeInterval? {
        return player?.duration
    }

    public var isPlaying: Bool {
        return player?.isPlaying ?? false
    }

    public var url: URL? {
        return player?.url
    }

    public var rate: Float? {
        return player?.rate
    }

    // MARK: - Public methods

    func setAudio(from url: URL?) {
        if let url = url {
            player = createAudioPlayer(with: url)
            displayLink = createCaDisplayLink()
        } else {
            player = nil
            displayLink = nil
            updatePlayingProgress()
        }
    }

    func setCurrentTime(
        _ time: TimeInterval
        ) {

        player?.currentTime = time
//        updatePlayingProgress()
    }

    func play() {
        player?.play()
        displayLink?.isPaused = false
    }

    func pause() {
        let currentTime = player?.currentTime ?? 0
        player?.pause()
        player?.currentTime = currentTime
        displayLink?.isPaused = true
    }

    func stop() {
        player?.stop()
        displayLink?.isPaused = true
    }

    func setRate(_ rate: Float) {
        player?.rate = rate
    }

    // MARK: - Private methods

    private func createAudioPlayer(with url: URL) -> AVAudioPlayer? {
        let player = try? AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.numberOfLoops = 0
        player?.enableRate = true
        player?.prepareToPlay()
        return player
    }

    private func createCaDisplayLink() -> CADisplayLink {
        let link = CADisplayLink(target: self, selector: #selector(updatePlayingProgress))
        link.preferredFramesPerSecond = 4
        link.add(to: RunLoop.main, forMode: .common)
        link.isPaused = true
        return link
    }

    @objc private func updatePlayingProgress() {
        onPlaying?(currentTime, duration)
    }
}

extension PlayerService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onDidFinishPlaying?()
    }
}
