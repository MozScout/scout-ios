import Foundation
import RxSwift

// MARK: - Protocol

protocol PlayerInteractor: class {
    func onViewDidLoadSync(request: Player.Event.ViewDidLoadSync.Request)
    func onViewDidLoad(request: Player.Event.ViewDidLoad.Request)
    func onDidTapPlayButton(request: Player.Event.DidTapPlayButton.Request)
    func onCloseSync(request: Player.Event.CloseSync.Request)
    func onViewWillAppear(request: Player.Event.ViewWillAppear.Request)
    func onDidSelectItem(request: Player.Event.DidSelectItem.Request)
    func onDidScrollItemsList(request: Player.Event.DidScrollItemsList.Request)
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
        private let itemProvider: ItemProvider

        private let disposeBag: DisposeBag = DisposeBag()

        private var sceneModel: Model.SceneModel

        // MARK: -
        
        init(
            presenter: Presenter,
            playerManager: PlayerCoordinator,
            itemProvider: ItemProvider
            ) {

            self.presenter = presenter
            self.playerManager = playerManager
            self.itemProvider = itemProvider

            sceneModel = Model.SceneModel(
                playerState: .paused,
                items: []
            )
        }

        private func observeItem() {
            itemProvider
                .observeItem()
                .subscribe(onNext: { [weak self] (item) in
                    self?.playerManager.playAudio(from: item?.audioUrl)
                })
                .disposed(by: disposeBag)
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

        private func sendItemsDidUpdate() {

            let response = Event.PlayerItemsDidUpdate.Response(items: sceneModel.items)
            presenter.presentItemsDidUpdate(response: response)
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

        private func observeItems() {

            sceneModel.items = [
                Model.ItemModel(
                    imageUrl: URL(string: "https://www.kolesa.ru/uploads/2018/03/gaz_21_volga_5.jpg")!,
                    identifier: ""
                ),
                Model.ItemModel(
                    imageUrl: URL(string: "https://a.d-cd.net/68afees-960.jpg")!,
                    identifier: ""
                )
            ]

            sendItemsDidUpdate()
        }
    }
}

//MARK: - Interactor

extension Player.InteractorImp: Player.Interactor {

    func onViewDidLoadSync(request: Player.Event.ViewDidLoadSync.Request) {
        playIfNeeded()
        observePlayerState()
        observeItems()
    }

    func onViewDidLoad(request: Player.Event.ViewDidLoad.Request) {
        observeItem()
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

    func onCloseSync(request: Player.Event.CloseSync.Request) {
        playerManager.playAudio(from: nil)

        let response = Player.Event.CloseSync.Response()
        presenter.presentCloseSync(response: response)
    }

    func onViewWillAppear(request: Player.Event.ViewWillAppear.Request) {
        sceneModel.playerState = .playing
        playIfNeeded()
    }

    func onDidSelectItem(request: Player.Event.DidSelectItem.Request) {
        if sceneModel.playerState != .paused {
            sceneModel.playerState = .paused
            playIfNeeded()
        }
        // TODO: - Select, load and play another item
    }

    func onDidScrollItemsList(request: Player.Event.DidScrollItemsList.Request) {
        if sceneModel.playerState != .paused {
            sceneModel.playerState = .paused
            playIfNeeded()
        }
    }
}
