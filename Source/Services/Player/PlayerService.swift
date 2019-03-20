//
//  PlayerService.swift
//  Scout
//
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa
import CoreMedia

class PlayerService: NSObject {

    struct Timings {
        let duration: TimeInterval
        let currentTime: TimeInterval
    }

    // MARK: - Private properties

    private var player: AVAudioPlayer? {
        didSet {
            durationDidUpdate()
            currentTimeDidUpdate()
        }
    }
    private var displayLink: CADisplayLink?

    private let timingsBehaviorRelay: BehaviorRelay<Timings?> = BehaviorRelay(value: nil)

    // MARK: - Public properties

    public var onDidFinishPlaying: (() -> Void)?

    public var currentTime: TimeInterval? {
        return timingsBehaviorRelay.value?.currentTime
    }

    public var duration: TimeInterval? {
        return timingsBehaviorRelay.value?.duration
    }

    public var isPlaying: Bool? {
        return player?.isPlaying
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
        currentTimeDidUpdate()
    }

    func play() {
        player?.play()
        player?.currentTime = player?.currentTime ?? 0
        displayLink?.isPaused = false
    }

    func pause() {
        player?.pause()
        displayLink?.isPaused = true
    }

    func setRate(_ rate: Float) {
        player?.rate = rate
    }

    func observeTimings() -> Observable<Timings?> {
        return timingsBehaviorRelay.asObservable()
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
        link.preferredFramesPerSecond = 6
        link.add(to: RunLoop.main, forMode: .common)
        link.isPaused = true
        return link
    }

    @objc private func updatePlayingProgress() {
        currentTimeDidUpdate()
    }

    private func currentTimeDidUpdate() {
        timingsDidUpdate()
    }

    private func durationDidUpdate() {
        timingsDidUpdate()
    }

    private func timingsDidUpdate() {
        let timings: Timings? = {
            if let player = player {
                return Timings(
                    duration: player.duration.rounded(.up),
                    currentTime: player.currentTime
                )
            } else {
                return nil
            }
        }()
        timingsBehaviorRelay.accept(timings)
    }
}

extension PlayerService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

        onDidFinishPlaying?()
    }
}
