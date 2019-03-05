import Foundation

// MARK: - Protocol

protocol PlayerPresenter {
    typealias Event = Player.Event

    func presentViewDidLoad(response: Event.ViewDidLoad.Response)
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

    func presentViewDidLoad(response: Event.ViewDidLoad.Response) {
        let viewModel = Event.ViewDidLoad.ViewModel()
        self.displayAsync { (viewController) in
            viewController.displayViewDidLoad(viewModel: viewModel)
        }
    }
}
