import Foundation

// MARK: - Protocol

protocol AddSubscriptionPresenter {
    typealias Event = AddSubscription.Event

    func presentViewDidLoad(response: Event.ViewDidLoad.Response)
    func presentTopicsDidUpdate(response: Event.TopicsDidUpdate.Response)
}

extension AddSubscription {
    typealias Presenter = AddSubscriptionPresenter

    // MARK: - Declaration

    class PresenterImp<Type: AddSubscriptionViewController> {

        typealias Model = AddSubscription.Model
        typealias Event = AddSubscription.Event

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

// MARK: - Private

private extension AddSubscription.PresenterImp {

    func sectionViewModelFromSection(_ section: Model.Section) -> Model.SectionViewModel {
        let headerTitle: String

        switch section.category {
        case .like:
            headerTitle = "Categories You Might Like"
        case .more:
            headerTitle = "More Categories"
        }

        return Model.SectionViewModel(
            sectionHeader: CategorySectionHeaderView.ViewModel(title: headerTitle),
            topics: section.topics.map( { topicViewModelFromTopic($0) } )
        )
    }

    func topicViewModelFromTopic(_ topic: Model.Topic) -> RoundTopicCell.ViewModel {
        return RoundTopicCell.ViewModel(
            topicId: topic.topicId,
            title: topic.title,
            imageUrl: URL(string: topic.imageUrl),
            isSelected: false
        )
    }
}

// MARK: - Presenter

extension AddSubscription.PresenterImp: AddSubscription.Presenter {

    func presentViewDidLoad(response: Event.ViewDidLoad.Response) {
        let viewModel = Event.ViewDidLoad.ViewModel()
        self.displayAsync { (viewController) in
            viewController.displayViewDidLoad(viewModel: viewModel)
        }
    }

    func presentTopicsDidUpdate(response: Event.TopicsDidUpdate.Response) {
        let viewModel = Event.TopicsDidUpdate.ViewModel(items: response.items.map( { sectionViewModelFromSection($0) } ))
        self.displayAsync { (viewController) in
            viewController.displayTopicsDidUpdate(viewModel: viewModel)
        }
    }
}
