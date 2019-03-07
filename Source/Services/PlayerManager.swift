//
//  PlayerManager.swift
//  Scout
//
//

import Foundation
import RxCocoa
import RxSwift

class PlayerManager {

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
    private let generalApi: GeneralApi

    private var currentCancellable: CancellableToken?

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
        generalApi: GeneralApi
        ) {

        self.playerService = playerService
        self.generalApi = generalApi
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

    public func playAudio(from url: URL) {
        currentCancellable?.cancel()
        loadingStateBehaviorRelay.accept(.loading)
        currentCancellable = loadAudio(
            from: url,
            completion: { [weak self] (result) in
                switch result {

                case .success:
                    self?.setAudio(from: url)
                    self?.playIfNeeded()

                case .failure:
                    break
                }
                self?.loadingStateBehaviorRelay.accept(.idle)
        })
    }

    // MARK: - Private methods

    private func loadAudio(
        from url: URL,
        completion: @escaping (GeneralApi.LoadAudioResult) -> Void
        ) -> CancellableToken {

        guard !ifAudioIsDownloaded(from: url) else {
            completion(.success)
            return EmptyCancellableToken()
        }

        return generalApi.loadAudio(
            from: url,
            to: localUrl(from: url),
            completion: completion
        )
    }

    private func setAudio(
        from url: URL
        ) {

        playerService.setAudio(from: localUrl(from: url))
    }

    private func playIfNeeded() {
        switch playerState {

        case .playing:
            play()

        case .paused:
            pause()
        }
    }

    private func ifAudioIsDownloaded(from url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }

    private func localUrl(from url: URL) -> URL {
        var localUrl: URL!

        repeat {
            localUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        } while localUrl == nil

        if localUrl == nil {
            print(.fatalError(error: "Cannot get url"))
            localUrl = FileManager.default.temporaryDirectory
        }

        return localUrl.appendingPathComponent(url.lastPathComponent)
    }
}
