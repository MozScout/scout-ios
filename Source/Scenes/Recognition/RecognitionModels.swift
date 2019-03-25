import Foundation

// MARK: - Namespace

enum Recognition {

    // MARK: - Typealiases

    typealias InteractorDispatcher = Dispatcher<Interactor>
    typealias PresenterDispatcher<Type: ViewController> = Dispatcher<Weak<Type>>
    typealias ViewController = RecognitionViewController
    typealias ViewControllerImp = RecognitionViewControllerImp

    // MARK: - Subspaces

    enum Model {}
    enum Event {}
}

// MARK: - Models

extension Recognition.Model {
    
}

// MARK: - Events

extension Recognition.Event {

    typealias Model = Recognition.Model
    
    enum ViewDidLoad {

        struct Request {}

        struct Response {}

        struct ViewModel {
            let title: String
        }
    }
}
