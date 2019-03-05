import Foundation

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
    
    enum ViewDidLoad {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }
}

extension Player.Model.SceneModel {
    enum PlayerState {
        case playing
        case paused
    }
}
