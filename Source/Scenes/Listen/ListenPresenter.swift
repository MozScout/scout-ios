import Foundation

// MARK: - Protocol

protocol ListenPresenter {
    typealias Event = Listen.Event

    func presentViewDidLoad(response: Event.ViewDidLoad.Response)
    func presentItemsDidUpdate(response: Event.ItemsDidUpdate.Response)
    func presentDidChangeEditing(response: Event.DidChangeEditing.Response)
}

extension Listen {
    typealias Presenter = ListenPresenter

    // MARK: - Declaration

    class PresenterImp<Type: ListenViewController> {

        typealias Model = Listen.Model
        typealias Event = Listen.Event

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

extension Listen.PresenterImp: Listen.Presenter {

    func presentViewDidLoad(response: Event.ViewDidLoad.Response) {
        displayAsync { (viewController) in
            viewController.displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel(editingButtonTitle: "Edit"))
        }
    }

    func presentItemsDidUpdate(response: Event.ItemsDidUpdate.Response) {
        displayAsync { (viewController) in
            let itemsViewModels = response.items.map {
                ListenTableViewCell.ViewModel.init(
                    itemId: $0.itemId,
                    imageUrl: URL(string: $0.imageUrl),
                    iconUrl: URL(string: $0.iconUrl),
                    publisher: $0.publisher,
                    title: $0.title,
                    duration: $0.duration,
                    summary: $0.summary,
                    episode: $0.episode
                )
            }

            viewController.displayItemsDidUpdate(viewModel: Event.ItemsDidUpdate.ViewModel(items: itemsViewModels))
        }
    }

    func presentDidChangeEditing(response: Event.DidChangeEditing.Response) {
        displayAsync { (viewController) in
            viewController.displayDidChangeEditing(
                viewModel: Event.DidChangeEditing.ViewModel(
                    isEditing: response.isEditing,
                    editingButtonTitle: response.isEditing ? "Cancel" : "Edit"
                )
            )
        }
    }
}
