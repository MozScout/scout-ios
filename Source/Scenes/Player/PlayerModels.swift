import UIKit

// MARK: - Namespace

enum Player {

    // MARK: - Typealiases

    typealias Identifier = String

    typealias InteractorDispatcher = Dispatcher<Interactor>
    typealias PresenterDispatcher<Type: ViewController> = Dispatcher<Weak<Type>>

    // MARK: - Subspaces

    enum Model {}
    enum Event {}
}

// MARK: - Models

extension Player.Model {
    struct SceneModel {
        var playerState: PlayerState
        var items: [ItemModel]
        var track: Track?
    }

    struct Item {
        let title: String
        let author: String
        let lengthMinutes: Int64
        let audioUrl: URL
        let imageUrl: URL
        let publisher: String
        let excerpt: String
        let iconUrl: URL
    }

    struct ItemModel {
        let imageUrl: URL
        let identifier: Player.Identifier
    }

    struct ItemViewModel {
        let imageUrl: URL
        let identifier: Player.Identifier
    }
}

extension Player.Model.SceneModel {
    struct Track {
        let played: Int64
        let duration: Int64
    }
}

// MARK: - Events

extension Player.Event {
    typealias Model = Player.Model

    enum ViewDidLoad {
        struct Request { }
    }
    
    enum ViewDidLoadSync {
        struct Request { }
    }

    enum DidSelectItem {
        struct Request {
            let id: Player.Identifier
        }
    }

    enum DidScrollItemsList {
        struct Request { }
    }

    enum ViewWillAppear {
        struct Request { }
    }

    enum DidTapPlayButton {

        struct Request { }
    }

    enum CloseSync {

        struct Request { }
        struct Response { }
        struct ViewModel { }
    }

    enum PlayerItemsDidUpdate {

        struct Response {
            let items: [Model.ItemModel]
        }

        struct ViewModel {
            let items: [Model.ItemViewModel]
            let selectedIndexPath: IndexPath?
        }
    }

    enum PlayerStateDidUpdate {

        struct Response {
            let state: Model.SceneModel.PlayerState
        }

        struct ViewModel {
            let playButtonIcon: UIImage
        }
    }

    enum PlayerTrackDidUpdate {

        struct Response {
            let track: Model.SceneModel.Track?
        }

        struct ViewModel {
            let value: Float
            let played: String
            let remaining: String
        }
    }
}

extension Player.Model.SceneModel {
    enum PlayerState {
        case playing
        case paused
    }
}
