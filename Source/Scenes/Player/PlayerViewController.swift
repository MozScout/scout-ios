import UIKit

// MARK: - Protocol

protocol PlayerViewController: class {
    typealias Event = Player.Event

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel)
}

extension Player {
    typealias ViewController = PlayerViewController

    typealias ViewControllerImp = PlayerViewControllerImp
}

class PlayerViewControllerImp: UIViewController {

    typealias Model = Player.Model
    typealias Event = Player.Event

    typealias Interactor = Player.Interactor
    typealias InteractorDispatcher = Player.InteractorDispatcher
    typealias Output = Player.Output

    // MARK: Private Properties

    private let output: Output
    private var interactorDispatcher: InteractorDispatcher!

    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!

    // MARK: Initializing

    init(output: Output) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Injections

    func inject(interactorDispatcher: InteractorDispatcher) {
        self.interactorDispatcher = interactorDispatcher
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        //            let request = Event.ViewDidLoad.Request()
        //            sendAsync { (interactor) in
        //                interactor.onViewDidLoad(request: request)
        //            }
    }

    // MARK: - Private methods

    private func sendSync<Result>(_ block: (Interactor) -> Result) -> Result {
        return self.interactorDispatcher.sync { (interactor) in
            block(interactor)
        }
    }

    private func sendAsync(_ block: @escaping (Interactor) -> Void) {
        self.interactorDispatcher.async { (interactor) in
            block(interactor)
        }
    }
}

extension Player.ViewControllerImp: Player.ViewController {

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel) {
        
    }
}
