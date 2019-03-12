import UIKit

// MARK: - Protocol

protocol PlayerPresenter {

    func presentPlayerStateDidUpdate(response: Player.Event.PlayerStateDidUpdate.Response)
    func presentPlayerItemDidUpdate(response: Player.Event.PlayerItemDidUpdate.Response)
    func presentCloseSync(response: Player.Event.CloseSync.Response)
}

extension Player {
    typealias Presenter = PlayerPresenter

    // MARK: - Declaration

    class PresenterImp<Type: PlayerViewController> {

        typealias Model = Player.Model
        typealias Event = Player.Event

        // MARK: - Private properties

        private let presenterDispatcher: PresenterDispatcher<Type>

        // MARK: -

        init(presenterDispatcher: PresenterDispatcher<Type>) {
            self.presenterDispatcher = presenterDispatcher
        }

        // MARK: - Private methods

        private func displaySync(_ block: (ViewController) -> Void) {
            self.presenterDispatcher.sync { (weakViewController) in
                if let viewController = weakViewController.obj {
                    block(viewController)
                }
            }
        }

        private func displayAsync(_ block: @escaping (ViewController) -> Void) {
            self.presenterDispatcher.async { (weakViewController) in
                if let viewController = weakViewController.obj {
                    block(viewController)
                }
            }
        }
    }
}

//MARK: - Presenter

extension Player.PresenterImp: Player.Presenter {

    func presentPlayerStateDidUpdate(response: Player.Event.PlayerStateDidUpdate.Response) {
        let icon: UIImage = {
            switch response.state {
            case .playing:
                return UIImage.fxPause
            case .paused:
                return UIImage.fxPlay
            }
        }()
        let viewModel = Player.Event.PlayerStateDidUpdate.ViewModel(playButtonIcon: icon)
        displayAsync { (viewController) in
            viewController.displayPlayerStateDidUpdate(viewModel: viewModel)
        }
    }

    func presentPlayerItemDidUpdate(response: Player.Event.PlayerItemDidUpdate.Response) {
        let viewModel = Player.Event.PlayerItemDidUpdate.ViewModel(
            imageUrl: response.imageUrl,
            title: response.title
        )
        displayAsync { (viewController) in
            viewController.displayPlauerItemDidUpdate(viewModel: viewModel)
        }
    }

    func presentCloseSync(response: Player.Event.CloseSync.Response) {
        let viewModel = Player.Event.CloseSync.ViewModel()
        displayAsync { (viewController) in
            viewController.displayCloseSync(viewModel: viewModel)
        }
    }
}
