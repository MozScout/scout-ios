import Foundation

// MARK: - Protocol

protocol HandsFreeModePresenter {
    typealias Event = HandsFreeMode.Event

    func presentViewDidLoad(response: Event.ViewDidLoad.Response)
    func presentModeDidSwitched(response: Event.ModeDidSwitched.Response)
}

extension HandsFreeMode {
    typealias Presenter = HandsFreeModePresenter

    // MARK: - Declaration

    class PresenterImp<Type: HandsFreeModeViewController> {

        typealias Model = HandsFreeMode.Model
        typealias Event = HandsFreeMode.Event

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

extension HandsFreeMode.PresenterImp: HandsFreeMode.Presenter {

    func presentViewDidLoad(response: Event.ViewDidLoad.Response) {
        let viewModel = Event.ViewDidLoad.ViewModel(
            title: "Hands Free Mode",
            isHandsFreeModeEnabled: response.isHandsFreeModeEnabled,
            switchTitle: "Listen for “Hey Firefox”"
        )

        self.displayAsync { (viewController) in
            viewController.displayViewDidLoad(viewModel: viewModel)
        }
    }

    func presentModeDidSwitched(response: Event.ModeDidSwitched.Response) {
        let viewModel = Event.ModeDidSwitched.ViewModel(isHandsFreeModeEnabled: response.isHandsFreeModeEnabled)
        self.displayAsync { (viewController) in
            viewController.displayModeDidSwitched(viewModel: viewModel)
        }
    }
}
