import Foundation

// MARK: - Protocol

protocol SubscriptionsPresenter {

    func presentViewDidLoad(response: Subscriptions.Event.ViewDidLoad.Response)
    func presentSectionsDidUpdate(response: Subscriptions.Event.SectionsDidUpdate.Response)
    func presentRefreshDidFinish(response: Subscriptions.Event.RefreshDidFinish.Response)
}

extension Subscriptions {
    typealias Presenter = SubscriptionsPresenter

    // MARK: - Declaration

    class PresenterImp<Type: SubscriptionsViewController> {

        typealias Model = Subscriptions.Model
        typealias Event = Subscriptions.Event

        // MARK: - Private properties

        private let presenterDispatcher: PresenterDispatcher<Type>

        private let dateFormatter: DateFormatter

        // MARK: -

        init(
            presenterDispatcher: PresenterDispatcher<Type>,
            dateFormatter: DateFormatter
            ) {

            self.presenterDispatcher = presenterDispatcher
            self.dateFormatter = dateFormatter
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

    func presentViewDidLoad(response: Subscriptions.Event.ViewDidLoad.Response) {
        let viewModel = Event.ViewDidLoad.ViewModel()
        self.displayAsync { (viewController) in
            viewController.displayViewDidLoad(viewModel: viewModel)
        }
    }

    func presentSectionsDidUpdate(response: Subscriptions.Event.SectionsDidUpdate.Response) {

        let viewModel: Event.SectionsDidUpdate.ViewModel

        if response.sections.isEmpty {
            viewModel = .empty
        } else {
            let sections = response.sections.map { (section) -> Model.SectionViewModel in
                let titleViewModel = SubscriptionsHeaderSupplementaryView.ViewModel(title: section.title)

                let itemsViewModels = section.items.map { (item) -> SubscriptionsItemCell.ViewModel in
                    return SubscriptionsItemCell.ViewModel(
                        iconUrl: item.iconUrl,
                        date: dateFormatter.formatItemDate(item.date),
                        title: item.title
                    )
                }
                let groupViewModels = [SubscriptionsGroupCell.ViewModel(items: itemsViewModels)]

                return Model.SectionViewModel(
                    titleModel: titleViewModel,
                    viewModels: groupViewModels
                )
            }
            viewModel = .full(sections)
        }

        self.displayAsync { (viewController) in
            viewController.displaySectionsDidUpdate(viewModel: viewModel)
        }
    }

    func presentRefreshDidFinish(response: Subscriptions.Event.RefreshDidFinish.Response) {
        let viewModel = Subscriptions.Event.RefreshDidFinish.ViewModel()
        self.displayAsync { (viewController) in
            viewController.displayRefreshDidFinish(viewModel: viewModel)
        }
    }
}
