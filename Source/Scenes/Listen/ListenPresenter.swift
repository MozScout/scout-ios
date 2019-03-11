import Foundation

// MARK: - Protocol

protocol ListenPresenter {
    typealias Event = Listen.Event

    func presentViewDidLoad(response: Event.ViewDidLoad.Response)
    func presentItemsDidUpdate(response: Event.ItemsDidUpdate.Response)
    func presentDidChangeEditing(response: Event.DidChangeEditing.Response)
    func presentDidStartFetching(response: Event.DidStartFetching.Response)
    func presentDidEndFetching(response: Event.DidEndFetching.Response)
}

extension Listen {
    typealias Presenter = ListenPresenter

    // MARK: - Declaration

    class PresenterImp<Type: ListenViewController> {

        typealias Model = Listen.Model
        typealias Event = Listen.Event

        // MARK: - Private properties

        private let presenterDispatcher: PresenterDispatcher<Type>
        private let durationFormatter: DurationFormatter

        // MARK: -

        init(
            presenterDispatcher: PresenterDispatcher<Type>,
            durationFormatter: DurationFormatter
            ) {

            self.presenterDispatcher = presenterDispatcher
            self.durationFormatter = durationFormatter
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
        let itemsViewModels = response.items.map { (item) in
            return item.cellViewModel(with: durationFormatter)
        }
        displayAsync { (viewController) in
            viewController.displayItemsDidUpdate(viewModel: Event.ItemsDidUpdate.ViewModel(items: itemsViewModels))
        }
    }

    func presentDidChangeEditing(response: Event.DidChangeEditing.Response) {
        let viewModel = Event.DidChangeEditing.ViewModel(
            isEditing: response.isEditing,
            editingButtonTitle: response.isEditing ? "Cancel" : "Edit"
        )
        displayAsync { (viewController) in
            viewController.displayDidChangeEditing(viewModel: viewModel)
        }
    }

    func presentDidStartFetching(response: Event.DidStartFetching.Response) {
        displayAsync { (viewController) in
            viewController.displayDidStartFetching(viewModel: Event.DidStartFetching.ViewModel())
        }
    }

    func presentDidEndFetching(response: Event.DidEndFetching.Response) {
        displayAsync { (viewController) in
            viewController.displayDidEndFetching(viewModel: Event.DidEndFetching.ViewModel())
        }
    }
}

private extension Listen.Model.Item {

    func cellViewModel(
        with durationFormatter: Listen.DurationFormatter
        ) -> ListenTableViewCell.ViewModel {

        let summary: String? = {
            switch type {
            case .article:
                return "Summary"
            case .episode:
                return nil
            }
        }()

        return ListenTableViewCell.ViewModel(
            itemId: itemId,
            imageUrl: URL(string: imageUrl),
            iconUrl: iconUrl != nil ? URL(string: iconUrl!) : nil,
            publisher: publisher,
            title: title,
            duration: durationFormatter.format(duration: duration),
            summary: summary,
            episode: nil
        )
    }
}
