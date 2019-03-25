import Foundation

// MARK: - Namespace

enum HandsFreeMode {

    // MARK: - Typealiases

    typealias InteractorDispatcher = Dispatcher<Interactor>
    typealias PresenterDispatcher<Type: ViewController> = Dispatcher<Weak<Type>>
    typealias ViewController = HandsFreeModeViewController
    typealias ViewControllerImp = HandsFreeModeViewControllerImp

    // MARK: - Subspaces

    enum Model {}
    enum Event {}
}

// MARK: - Models

extension HandsFreeMode.Model {

    struct SceneModel {

        var isHandsFreeModeEnabled: Bool
    }
}

// MARK: - Events

extension HandsFreeMode.Event {

    typealias Model = HandsFreeMode.Model
    
    enum ViewDidLoad {

        struct Request {}

        struct Response {
            
            let isHandsFreeModeEnabled: Bool
        }

        struct ViewModel {

            let title: String
            let isHandsFreeModeEnabled: Bool
            let switchTitle: String
        }
    }

    enum ModeDidSwitched {

        struct Request {}

        struct Response {

            let isHandsFreeModeEnabled: Bool
        }

        struct ViewModel {

            let isHandsFreeModeEnabled: Bool
        }
    }
}
