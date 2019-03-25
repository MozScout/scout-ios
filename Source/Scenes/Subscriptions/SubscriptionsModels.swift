import Foundation

// MARK: - Namespace

enum Subscriptions {

    // MARK: - Typealiases

    typealias InteractorDispatcher = Dispatcher<Interactor>
    typealias PresenterDispatcher<Type: ViewController> = Dispatcher<Weak<Type>>

    // MARK: - Subspaces

    enum Model {}
    enum Event {}
}

// MARK: - Models

extension Subscriptions.Model {

    struct SceneModel {
        var sections: [Section]
    }

    struct Section {
        let title: String
        let items: [Item]
    }

    struct Item {
        let iconUrl: URL
        let title: String
        let date: Date
    }

    struct SectionViewModel {
        let titleModel: SubscriptionsHeaderSupplementaryView.ViewModel
        let viewModels: [SubscriptionsGroupCell.ViewModel]
    }
}

// MARK: - Events

extension Subscriptions.Event {
    typealias Model = Subscriptions.Model
    
    enum ViewDidLoad {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }

    enum RefreshDidStart {
        struct Request { }
    }

    enum RefreshDidFinish {
        struct Response { }
        struct ViewModel { }
    }

    enum SectionsDidUpdate {

        struct Response {
            let sections: [Model.Section]
        }

        enum ViewModel {
            case full([Model.SectionViewModel])
            case empty
        }
    }
}
