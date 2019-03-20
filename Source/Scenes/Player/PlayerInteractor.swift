import Foundation
import RxSwift

// MARK: - Protocol

protocol PlayerInteractor: class {
    func onViewDidLoadSync(request: Player.Event.ViewDidLoadSync.Request)
    func onViewDidLoad(request: Player.Event.ViewDidLoad.Request)
    func onDidTapPlayButton(request: Player.Event.DidTapPlayButton.Request)
    func onDidTapJumpBackward(request: Player.Event.DidTapJumpBackward.Request)
    func onDidTapJumpForward(request: Player.Event.DidTapJumpForward.Request)
    func onCloseSync(request: Player.Event.CloseSync.Request)
    func onViewDidAppear(request: Player.Event.ViewDidAppear.Request)
    func onDidSelectItem(request: Player.Event.DidSelectItem.Request)
    func onDidScrollItemsList(request: Player.Event.DidScrollItemsList.Request)
    func onPlayerSliderDidChangeValue(request: Player.Event.PlayerSliderDidChangeValue.Request)
    func onPlayerSliderDidCommitValue(request: Player.Event.PlayerSliderDidCommitValue.Request)
    func onDidClickPlayerSpeedButton(request: Player.Event.DidClickPlayerSpeedButton.Request)
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
        private var shouldUpdateTimings: Bool = true

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
                items: [],
                track: nil,
                currentSpeed: 1
            )
        }

        private func observeItem() {
            itemProvider
                .observeItem()
                .subscribe(onNext: { [weak self] (item) in
                    self?.playerManager.playAudio(from: item?.audioUrl)
                    if let duration = item?.lengthMinutes {
                        self?.sceneModel.track = Model.SceneModel.Track(
                            played: 0,
                            duration: TimeInterval(duration * 60)
                        )
                    }
                    self?.sendPlayerItemDidUpdate()
                })
                .disposed(by: disposeBag)
        }

        private func observeTrack() {
            playerManager
                .observeTimings()
                .asObservable()
                .subscribe(onNext: { [weak self] (timings) in
                    guard self?.shouldUpdateTimings == true else { return }

                    if let timings = timings {
                        let track = Model.SceneModel.Track(
                            played: timings.currentTime,
                            duration: timings.duration
                        )
                        self?.sceneModel.track = track
                    } else {
                        self?.sceneModel.track = nil
                    }
                    self?.sendPlayerTimingsDidUpdate(self?.sceneModel.track)
                })
                .disposed(by: disposeBag)
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
                ),
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

        private func sendPlayerStateDidUpdate() {

            let response = Event.PlayerStateDidUpdate.Response(state: sceneModel.playerState)
            presenter.presentPlayerStateDidUpdate(response: response)
        }

        private func sendItemsDidUpdate() {

            let response = Event.PlayerItemsDidUpdate.Response(items: sceneModel.items)
            presenter.presentItemsDidUpdate(response: response)
        }

        private func sendPlayerTimingsDidUpdate(_ track: Model.SceneModel.Track?) {

            let response = Event.PlayerTimingsDidUpdate.Response(track: track)
            presenter.presentPlayerTimingsDidUpdate(response: response)
        }

        private func sendPlayerSpeedDidUpdate() {

            let response = Player.Event.DidClickPlayerSpeedButton.Response(currentSpeed: sceneModel.currentSpeed)
            presenter.presentDidClickPlayerSpeedButton(response: response)
        }

        private func sendPlayerItemDidUpdate() {

            let response = Event.PlayerItemDidUpdate.Response(
                titleItem: Player.Event.PlayerItemDidUpdate.ViewModel.TitleItem.icon(URL(string: "https://a.d-cd.net/68afees-960.jpg")!),
                publisher: "Some publisher",
                publishingDate: Date(),
                title: "Title to test behavior of title label with multiline text of title",
                duration: sceneModel.track?.duration
            )
            presenter.presentPlayerItemDidUpdate(response: response)
        }
    }
}

//MARK: - Interactor

extension Player.InteractorImp: Player.Interactor {

    func onViewDidLoadSync(request: Player.Event.ViewDidLoadSync.Request) {
        observePlayerState()
        observeItems()
        observeTrack()

        sendPlayerTimingsDidUpdate(self.sceneModel.track)
        sendPlayerSpeedDidUpdate()
    }

    func onViewDidLoad(request: Player.Event.ViewDidLoad.Request) {
        observeItem()
    }

    func onDidTapPlayButton(request: Player.Event.DidTapPlayButton.Request) {
        switch sceneModel.playerState {
        case .paused:
            playerManager.play()
        case .playing:
            playerManager.pause()
        }
    }

    func onCloseSync(request: Player.Event.CloseSync.Request) {
        playerManager.playAudio(from: nil)

        let response = Player.Event.CloseSync.Response()
        presenter.presentCloseSync(response: response)
    }

    func onViewDidAppear(request: Player.Event.ViewDidAppear.Request) {
        playerManager.play()
    }

    func onDidSelectItem(request: Player.Event.DidSelectItem.Request) {
        if sceneModel.playerState != .paused {
            playerManager.pause()
        }
        // TODO: - Select, load and play another item
    }

    func onDidScrollItemsList(request: Player.Event.DidScrollItemsList.Request) {
        if sceneModel.playerState != .paused {
            playerManager.pause()
        }
    }

    func onPlayerSliderDidChangeValue(request: Player.Event.PlayerSliderDidChangeValue.Request) {
        shouldUpdateTimings = false
        guard let duration = sceneModel.track?.duration else {
            return
        }
        let track = Model.SceneModel.Track(played: TimeInterval(request.value), duration: duration)
        sendPlayerTimingsDidUpdate(track)
    }

    func onPlayerSliderDidCommitValue(request: Player.Event.PlayerSliderDidCommitValue.Request) {
        playerManager.setCurrentTime(TimeInterval(request.value))
        shouldUpdateTimings = true
    }

    func onDidClickPlayerSpeedButton(request: Player.Event.DidClickPlayerSpeedButton.Request) {

        if sceneModel.currentSpeed + sceneModel.speedStep > sceneModel.maximumSpeed {
            sceneModel.currentSpeed = sceneModel.minimumSpeed
        } else {
            sceneModel.currentSpeed = sceneModel.currentSpeed + sceneModel.speedStep
        }

        playerManager.setRate((sceneModel.currentSpeed as NSDecimalNumber).floatValue)
        sendPlayerSpeedDidUpdate()
    }

    func onDidTapJumpBackward(request: Player.Event.DidTapJumpBackward.Request) {
        updateTime(with: -10)
    }

    func onDidTapJumpForward(request: Player.Event.DidTapJumpForward.Request) {
        updateTime(with: 30)
    }

    private func updateTime(with constant: TimeInterval) {
        guard let currentTime = playerManager.currentTime else { return }

        let newTime = currentTime + constant
        playerManager.setCurrentTime(newTime)
    }
}
