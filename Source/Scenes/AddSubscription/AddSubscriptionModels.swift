import Foundation
import DifferenceKit

// MARK: - Namespace

enum AddSubscription {

    // MARK: - Typealiases

    typealias InteractorDispatcher = Dispatcher<Interactor>
    typealias PresenterDispatcher<Type: ViewController> = Dispatcher<Weak<Type>>

    // MARK: - Subspaces

    enum Model {}
    enum Event {}
}

// MARK: - Models

extension AddSubscription.Model {

    struct SceneModel {

        var items: [Section]
    }

    struct SectionViewModel: Equatable {
        
        let sectionHeader: CategorySectionHeaderView.ViewModel
        let topics: [RoundTopicCell.ViewModel]
    }

    struct Section {

        let category: Category
        var topics: [Topic]
    }

    enum Category {

        case like
        case more
    }

    struct Topic {

        let topicId: String
        let imageUrl: String
        let title: String
    }
}

// MARK: - Events

extension AddSubscription.Event {
    typealias Model = AddSubscription.Model
    
    enum ViewDidLoad {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }

    enum TopicsDidUpdate {

        struct Response {

            var items: [Model.Section]
        }

        struct ViewModel {

            var items: [Model.SectionViewModel]
        }
    }

    enum DidStartFetching {

        struct Response {}
        struct ViewModel {}
    }

    enum DidEndFetching {

        struct Response {}
        struct ViewModel {}
    }
}
