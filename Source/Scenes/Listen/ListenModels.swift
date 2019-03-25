import Foundation

// MARK: - Namespace

enum Listen {

    // MARK: - Typealiases

    typealias Identifier = String

    typealias InteractorDispatcher = Dispatcher<Interactor>
    typealias PresenterDispatcher<Type: ViewController> = Dispatcher<Weak<Type>>
    typealias ViewController = ListenViewController
    typealias ViewControllerImp = ListenViewControllerImp

    // MARK: - Subspaces

    enum Model {}
    enum Event {}
}

// MARK: - Models

extension Listen.Model {

    enum Mode {
        case list
        case search
    }

    struct Item {

        let itemId: Listen.Identifier
        let imageUrl: URL
        let iconUrl: URL?
        let publisher: String?
        let title: String
        let duration: Int64
        let type: ItemType
    }

    struct SceneModel {

        let mode: Mode
        var items: [Item]
        var isEditing: Bool
    }

    enum LoadingStatus {

        case loading
        case idle
    }
}

extension Listen.Model.Item {
    enum ItemType {

        case article
        case episode
    }
}

// MARK: - Events

extension Listen.Event {
    typealias Model = Listen.Model
    
    enum ViewDidLoad {

        struct Request {}

        struct Response {
            
            let mode: Model.Mode
        }

        struct ViewModel {

            let mode: Model.Mode
            let editingButtonTitle: String
        }
    }

    enum ItemsDidUpdate {

        struct Response {
            var items: [Model.Item]
        }

        struct ViewModel {
            var items: [ListenTableViewCell.ViewModel]
        }
    }

    enum DidSelectItem {
        
        struct Request {

            let itemId: String
        }

        struct Response {}
        struct ViewModel {}
    }

    enum DidRemoveItem {

        struct Request {

            let itemId: String
        }
    }

    enum DidPressSummary {

        struct Request {

            let itemId: String
        }

        struct Response {}
        struct ViewModel {}
    }

    enum DidChangeEditing {

        struct Request {}

        struct Response {

            var isEditing: Bool
        }

        struct ViewModel {

            var isEditing: Bool
            let editingButtonTitle: String
        }
    }

    enum DidRefreshItems {

        struct Request {}
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
