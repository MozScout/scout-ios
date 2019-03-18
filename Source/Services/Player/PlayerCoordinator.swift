//
//  PlayerCoordinator.swift
//  Scout
//
//

import Foundation
import RxCocoa
import RxSwift

class PlayerCoordinator {

    enum LoadingState {
        case loading
        case idle
    }

    enum PlayerState {
        case playing
        case paused
    }

    // MARK: - Private properties

    private let playerService: PlayerService
    private let playerAudioLoader: PlayerAudioLoader

    private let loadingStateBehaviorRelay: BehaviorRelay<LoadingState> = BehaviorRelay(value: .idle)
    private let playerStateBehaviorRelay: BehaviorRelay<PlayerState> = BehaviorRelay(value: .paused)

    // MARK: - Public properties

    public var loadingState: LoadingState {
        return loadingStateBehaviorRelay.value
    }

    public var playerState: PlayerState {
        return playerStateBehaviorRelay.value
    }

    public var onDidFinishPlaying: (() -> Void)? {
        get { return playerService.onDidFinishPlaying }
        set { playerService.onDidFinishPlaying = newValue }
    }
    public var onPlaying: ((_ currentTime: TimeInterval?, _ duration: TimeInterval?) -> Void)? {
        get { return playerService.onPlaying }
        set { playerService.onPlaying = newValue }
    }

    public var currentTime: TimeInterval? { return playerService.currentTime }
    public var duration: TimeInterval? { return playerService.duration }
    public var isPlaying: Bool { return playerService.isPlaying }
    public var url: URL? { return playerService.url }
    public var rate: Float? { return playerService.rate }

    // MARK: -

    init(
        playerService: PlayerService,
        playerAudioLoader: PlayerAudioLoader
        ) {

        self.playerService = playerService
        self.playerAudioLoader = playerAudioLoader
    }

    // MARK: - Public methods

    public func observeLoadingState() -> Observable<LoadingState> {
        return loadingStateBehaviorRelay.asObservable()
    }

    public func observePlayerState() -> Observable<PlayerState> {
        return playerStateBehaviorRelay.asObservable()
    }

    public func play() {
        playerService.play()
        playerStateBehaviorRelay.accept(.playing)
    }

    public func pause() {
        playerService.pause()
        playerStateBehaviorRelay.accept(.paused)
    }

    public func playAudio(from url: URL?) {

        setAudio(from: nil)

        guard let url = url else { return }

        loadingStateBehaviorRelay.accept(.loading)

        playerAudioLoader.loadAudio(from: url) { [weak self] (result) in
            self?.loadAudioCompletion(result)
            self?.loadingStateBehaviorRelay.accept(.idle)
        }
    }

    public func setCurrentTime(_ time: TimeInterval) {

        playerService.setCurrentTime(time)
    }

    public func setRate(_ rate: Float) {

        playerService.setRate(rate)
    }

    // MARK: - Private methods

    private func loadAudioCompletion(_ result: PlayerAudioLoader.LoadAudioResult) {
        switch result {

        case .success(let localUrl):
            setAudio(from: localUrl)
            playIfNeeded()

        case .failure:
            break
        }
    }

    private func setAudio(from url: URL?) {

        playerService.setAudio(from: url)
    }

    private func playIfNeeded() {
        switch playerState {

        case .playing:
            play()

        case .paused:
            pause()
        }
    }
}
