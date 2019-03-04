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
    
}

// MARK: - Events

extension Subscriptions.Event {
    typealias Model = Subscriptions.Model
    
    enum ViewDidLoad {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }
}
