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

    public func playSummary(from url: URL) {

        setAudio(from: nil)
        loadingStateBehaviorRelay.accept(.loading)

        playerAudioLoader.loadSummary(for: url) { [weak self] (result) in
            self?.loadAudioCompletion(result)
            self?.loadingStateBehaviorRelay.accept(.idle)
        }
    }

    public func playArticle(from url: URL) {

        setAudio(from: nil)
        loadingStateBehaviorRelay.accept(.loading)

        playerAudioLoader.loadArticle(for: url) { [weak self] (result) in
            self?.loadAudioCompletion(result)
            self?.loadingStateBehaviorRelay.accept(.idle)
        }
    }

    public func playAudio(from url: URL) {

        setAudio(from: nil)
        loadingStateBehaviorRelay.accept(.loading)

        playerAudioLoader.loadAudio(from: url) { [weak self] (result) in
            self?.loadAudioCompletion(result)
            self?.loadingStateBehaviorRelay.accept(.idle)
        }
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

    private func setAudio(
        from url: URL?
        ) {

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
