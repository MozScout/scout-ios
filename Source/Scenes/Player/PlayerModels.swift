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
        var currentSpeed: Decimal
        let maximumSpeed: Decimal = 2
        let minimumSpeed: Decimal = 0.5
        let speedStep: Decimal = 0.5
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
        let played: TimeInterval
        let duration: TimeInterval
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

    enum ViewDidAppear {
        struct Request { }
    }

    enum DidTapPlayButton {

        struct Request { }
    }

    enum DidTapJumpBackward {

        struct Request { }
    }

    enum DidTapJumpForward {

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

    enum PlayerItemDidUpdate {

        struct Response {
            let titleItem: ViewModel.TitleItem?
            let publisher: String?
            let publishingDate: Date?
            let title: String?
            let duration: TimeInterval?
        }

        struct ViewModel {
            let titleItem: TitleItem?
            let details: String?
            let title: NSAttributedString?
            let sliderMaximumValue: Float

            enum TitleItem {
                case icon(URL)
                case title(String)
            }
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

    enum PlayerSliderDidChangeValue {

        struct Request {
            let value: Float
        }
    }

    enum PlayerSliderDidCommitValue {

        struct Request {
            let value: Float
        }
    }

    enum PlayerTimingsDidUpdate {

        struct Response {
            let track: Model.SceneModel.Track?
        }

        struct ViewModel {
            let played: String
            let remaining: String

            let value: Float
            let maximumValue: Float
        }
    }

    enum DidClickPlayerSpeedButton {

        struct Request { }

        struct Response {
            let currentSpeed: Decimal
        }

        struct ViewModel {
            let speedButtonValue: String
        }
    }
}

extension Player.Model.SceneModel {
    enum PlayerState {
        case playing
        case paused
    }
}
