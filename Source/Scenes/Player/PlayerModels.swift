import UIKit

// MARK: - Namespace

enum Player {

    // MARK: - Typealiases

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
    }
}

// MARK: - Events

extension Player.Event {
    typealias Model = Player.Model
    
    enum ViewDidLoadSync {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }

    enum DidTapPlayButton {

        struct Request { }
    }

    enum PlayerItemDidUpdate {

        struct Response {
            let imageUrl: URL
            let title: String
        }

        struct ViewModel {
            let imageUrl: URL
            let title: String
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
}

extension Player.Model.SceneModel {
    enum PlayerState {
        case playing
        case paused
    }
}
