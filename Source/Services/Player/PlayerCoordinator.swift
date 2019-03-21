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
    private let audioLoader: AudioLoader
    private let playerCache: PlayerCache

    private let loadingStateBehaviorRelay: BehaviorRelay<LoadingState> = BehaviorRelay(value: .idle)
    private let playerStateBehaviorRelay: BehaviorRelay<PlayerState> = BehaviorRelay(value: .paused)

    private var cancellable: CancellableToken?

    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Public properties

    public var loadingState: LoadingState { return loadingStateBehaviorRelay.value }
    public var playerState: PlayerState { return playerStateBehaviorRelay.value }

    public var currentTime: TimeInterval? { return playerService.currentTime }
    public var duration: TimeInterval? { return playerService.duration }
    public var url: URL? { return playerService.url }
    public var rate: Float? { return playerService.rate }
    public var volume: Float? { return playerService.volume }

    // MARK: -

    init(
        playerService: PlayerService,
        audioLoader: AudioLoader,
        playerCache: PlayerCache
        ) {

        self.playerService = playerService
        self.audioLoader = audioLoader
        self.playerCache = playerCache

        playerService.onDidFinishPlaying = { [weak self] in
            self?.playerStateBehaviorRelay.accept(.paused)
        }
    }

    // MARK: - Public methods

    public func observeLoadingState() -> Observable<LoadingState> { return loadingStateBehaviorRelay.asObservable() }
    public func observePlayerState() -> Observable<PlayerState> { return playerStateBehaviorRelay.asObservable() }
    public func observeTimings() -> Observable<PlayerService.Timings?> { return playerService.observeTimings() }
    public func play() {
        playerStateBehaviorRelay.accept(.playing)
        playIfNeeded()
    }
    public func pause() {
        playerStateBehaviorRelay.accept(.paused)
        playIfNeeded()
    }

    func setVolume(_ volume: Float) { playerService.setVolume(volume) }
    func volumeUp(by const: Int = 1) { playerService.volumeUp(by: Float(const) / 16.0) }
    func volumeDown(by const: Int = 1) { playerService.volumeDown(by: Float(const) / 16.0) }

    public func playAudio(from url: URL?) {

        cancellable?.cancel()
        setAudio(from: nil)

        guard let url = url else { return }

        if let cachedUrl = playerCache.cachedItemUrl(for: url) {
            setAudioAndPlayIfNeeded(from: cachedUrl)
        } else {

            loadingStateBehaviorRelay.accept(.loading)

            cancellable = audioLoader.loadAudio(from: url) { [weak self] (result) in

                self?.loadAudioCompletion(from: url, result)
                self?.loadingStateBehaviorRelay.accept(.idle)
            }
        }
    }

    public func setCurrentTime(_ time: TimeInterval) {

        playerService.setCurrentTime(time)
    }

    public func setRate(_ rate: Float) {

        playerService.setRate(rate)
    }

    // MARK: - Private methods

    private func loadAudioCompletion(from url: URL, _ result: AudioLoader.LoadAudioResult) {
        switch result {

        case .success(let localUrl):
            playerCache.cacheItemUrl(localUrl, for: url)
            setAudioAndPlayIfNeeded(from: localUrl)

        case .failure:
            break
        }
    }

    private func setAudioAndPlayIfNeeded(from url: URL?) {
        setAudio(from: url)
        playIfNeeded()
    }

    private func setAudio(from url: URL?) {

        playerService.setAudio(from: url)
    }

    private func playIfNeeded() {
        switch playerState {

        case .playing:
            playerService.play()

        case .paused:
            playerService.pause()
        }
    }
}

enum PlayerCoordinatorAudioLoaderLoadAudioResult {
    case success(localUrl: URL)
    case failure
}

protocol PlayerCoordinatorAudioLoader {

    typealias LoadAudioResult = PlayerCoordinatorAudioLoaderLoadAudioResult

    func loadAudio(
        from url: URL,
        callback: @escaping (LoadAudioResult) -> Void
        ) -> CancellableToken
}

extension PlayerCoordinator {

    typealias AudioLoader = PlayerCoordinatorAudioLoader
}

extension AudioLoader: PlayerCoordinator.AudioLoader {

    func loadAudio(
        from url: URL,
        callback: @escaping (PlayerCoordinator.AudioLoader.LoadAudioResult) -> Void
        ) -> CancellableToken {

        return loadAudio(from: url, completion: { (result) in
            switch result {

            case .success(let url):
                callback(.success(localUrl: url))

            case .failure:
                callback(.failure)
            }
        })
    }
}
