import Foundation

// MARK: - Protocol

protocol PlayerInteractor: class {
    func onViewDidLoadSync(request: Player.Event.ViewDidLoadSync.Request)
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
        private let playerWorker: PlayerWorker

        private var sceneModel: Model.SceneModel

        // MARK: -
        
        init(
            presenter: Presenter,
            playerWorker: PlayerWorker
            ) {

            self.presenter = presenter
            self.playerWorker = playerWorker

            sceneModel = Model.SceneModel(
                playerState: .paused
            )
        }

        private func playerStateDidUpdate() {
            switch sceneModel.playerState {

            case .paused:
                playerWorker.pause()

            case .playing:
                playerWorker.play()
            }

            let response = Event.PlayerStateDidUpdate.Response(state: sceneModel.playerState)
            presenter.presentPlayerStateDidUpdate(response: response)
        }
    }
}

//MARK: - Interactor

extension Player.InteractorImp: Player.Interactor {

    func onViewDidLoadSync(request: Player.Event.ViewDidLoadSync.Request) {
        playerStateDidUpdate()
    }

    func onDidTapPlayButton(request: Player.Event.DidTapPlayButton.Request) {
        switch sceneModel.playerState {
        case .paused:
            sceneModel.playerState = .playing
        case .playing:
            sceneModel.playerState = .paused
        }

        playerStateDidUpdate()
    }
}
