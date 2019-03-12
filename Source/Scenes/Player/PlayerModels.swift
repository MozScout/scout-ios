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
