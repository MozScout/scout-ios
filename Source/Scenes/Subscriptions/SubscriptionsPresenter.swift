import Foundation

// MARK: - Protocol

protocol SubscriptionsPresenter {
    typealias Event = Subscriptions.Event

    func presentViewDidLoad(response: Event.ViewDidLoad.Response)
}

extension Subscriptions {
    typealias Presenter = SubscriptionsPresenter

    // MARK: - Declaration

    class PresenterImp<Type: SubscriptionsViewController> {

        typealias Model = Subscriptions.Model
        typealias Event = Subscriptions.Event

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

extension Subscriptions.PresenterImp: Subscriptions.Presenter {

    func presentViewDidLoad(response: Event.ViewDidLoad.Response) {
        let viewModel = Event.ViewDidLoad.ViewModel()
        self.displayAsync { (viewController) in
            viewController.displayViewDidLoad(viewModel: viewModel)
        }
    }
}
