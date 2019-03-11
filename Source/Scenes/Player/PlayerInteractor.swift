import Foundation
import RxSwift

// MARK: - Protocol

protocol PlayerInteractor: class {
    func onViewDidLoadSync(request: Player.Event.ViewDidLoadSync.Request)
    func onViewDidLoad(request: Player.Event.ViewDidLoad.Request)
    func onDidTapPlayButton(request: Player.Event.DidTapPlayButton.Request)
}

extension Player {
    typealias Interactor = PlayerInteractor

    // MARK: - Declaration

    class InteractorImp {

        typealias Model = Player.Model
        typealias Event = Player.Event

        // MARK: - Private properties
        
        private let presenter: Presenter
        private let playerManager: PlayerCoordinator
        private let playerItemsProvider: PlayerItemsProvider

        private let disposeBag: DisposeBag = DisposeBag()

        private var sceneModel: Model.SceneModel

        // MARK: -
        
        init(
            presenter: Presenter,
            playerManager: PlayerCoordinator,
            playerItemsProvider: PlayerItemsProvider
            ) {

            self.presenter = presenter
            self.playerManager = playerManager
            self.playerItemsProvider = playerItemsProvider

            sceneModel = Model.SceneModel(
                playerState: .paused
            )
        }

        private func loadAudio() {
            guard
                let identifier = playerItemsProvider.selectedItemId,
                let item = playerItemsProvider.items.first(where: { $0.id == identifier })
                else {
                    return
            }

            switch item.type {

            case .article(let url):
                playerManager.playArticle(from: url)

            case .episode(let url):
                playerManager.playAudio(from: url)
            }
        }

        private func playIfNeeded() {
            switch sceneModel.playerState {

            case .paused:
                playerManager.pause()

            case .playing:
                playerManager.play()
            }
        }

        private func sendPlayerStateDidUpdate() {

            let response = Event.PlayerStateDidUpdate.Response(state: sceneModel.playerState)
            presenter.presentPlayerStateDidUpdate(response: response)
        }

        private func observePlayerState() {
            playerManager
                .observePlayerState()
                .subscribe(onNext: { [weak self] (state) in

                    switch state {

                    case .paused:
                        self?.sceneModel.playerState = .paused

                    case .playing:
                        self?.sceneModel.playerState = .playing
                    }

                    self?.sendPlayerStateDidUpdate()
                })
                .disposed(by: disposeBag)
        }
    }
}

//MARK: - Interactor

extension Player.InteractorImp: Player.Interactor {

    func onViewDidLoadSync(request: Player.Event.ViewDidLoadSync.Request) {
        playIfNeeded()
        observePlayerState()
    }

    func onViewDidLoad(request: Player.Event.ViewDidLoad.Request) {
        loadAudio()
    }

    func onDidTapPlayButton(request: Player.Event.DidTapPlayButton.Request) {
        switch sceneModel.playerState {
        case .paused:
            sceneModel.playerState = .playing
        case .playing:
            sceneModel.playerState = .paused
        }

        playIfNeeded()
    }
}
