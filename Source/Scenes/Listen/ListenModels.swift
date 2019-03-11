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

    struct Item {

        let itemId: Listen.Identifier
        let imageUrl: String
        let iconUrl: String?
        let publisher: String?
        let title: String
        let duration: Int64
        let type: ItemType
    }

    struct SceneModel {

        var items: [Item]
        var isEditing: Bool
    }
}

extension Listen.Model.Item {
    enum ItemType {

        case article(url: String)
        case episode(url: String)
    }
}

// MARK: - Events

extension Listen.Event {
    typealias Model = Listen.Model
    
    enum ViewDidLoad {

        struct Request {}
        struct Response {}

        struct ViewModel {

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
