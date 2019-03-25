import Foundation

// MARK: - Protocol

protocol RecognitionPresenter {
    typealias Event = Recognition.Event

    func presentViewDidLoad(response: Event.ViewDidLoad.Response)
}

extension Recognition {
    typealias Presenter = RecognitionPresenter

    // MARK: - Declaration

    class PresenterImp<Type: RecognitionViewController> {

        typealias Model = Recognition.Model
        typealias Event = Recognition.Event

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

extension Recognition.PresenterImp: Recognition.Presenter {

    func presentViewDidLoad(response: Event.ViewDidLoad.Response) {
        let viewModel = Event.ViewDidLoad.ViewModel(title: "Hands Free Mode")
        self.displayAsync { (viewController) in
            viewController.displayViewDidLoad(viewModel: viewModel)
        }
    }
}
