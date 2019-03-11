import UIKit

// MARK: - Protocol

protocol PlayerViewController: class {

    func displayPlayerStateDidUpdate(viewModel: Player.Event.PlayerStateDidUpdate.ViewModel)
    func displayPlauerItemDidUpdate(viewModel: Player.Event.PlayerItemDidUpdate.ViewModel)
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

        setupView()
        setupPlayButton()
        setupLeftButton()
        setupRightButton()

        let syncRequest = Event.ViewDidLoadSync.Request()
        sendSync { (interactor) in
            interactor.onViewDidLoadSync(request: syncRequest)
        }

        let request = Event.ViewDidLoad.Request()
        sendAsync { (interactor) in
            interactor.onViewDidLoad(request: request)
        }
    }

    // MARK: -

    @IBAction func playButtonAction(_ sender: Any) {
        sendAsync { (interactor) in
            let request = Event.DidTapPlayButton.Request()
            interactor.onDidTapPlayButton(request: request)
        }
    }

    @IBAction func leftButtonAction(_ sender: Any) {
    }

    @IBAction func rightButtonAction(_ sender: Any) {
    }

    // MARK: - Private methods

    private func setupView() {
        view.backgroundColor = UIColor.white
    }

    private func setupIconView() {
        iconView.layer.cornerRadius = 6
        iconView.layer.masksToBounds = true
    }

    private func setupPlayButton() {
        playButton.tintColor = UIColor.fxBlack
    }

    private func setupLeftButton() {
        leftButton.setImage(UIImage.fxJumpBack, for: .normal)
        leftButton.tintColor = UIColor.fxBlack
    }

    private func setupRightButton() {
        rightButton.setImage(UIImage.fxJumpForward, for: .normal)
        rightButton.tintColor = UIColor.fxBlack
    }

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

    func displayPlayerStateDidUpdate(viewModel: Player.Event.PlayerStateDidUpdate.ViewModel) {
        playButton.setImage(viewModel.playButtonIcon, for: .normal)
    }

    func displayPlauerItemDidUpdate(viewModel: Player.Event.PlayerItemDidUpdate.ViewModel) {
        iconView.kf.setImage(with: viewModel.imageUrl, placeholder: UIImage.fxPlaceholder)
        
    }
}
