import UIKit

// MARK: - Protocol

protocol PlayerViewController: class {

    func displayPlayerStateDidUpdate(viewModel: Player.Event.PlayerStateDidUpdate.ViewModel)
    func displayCloseSync(viewModel: Player.Event.CloseSync.ViewModel)
    func displayItemsDidUpdate(viewModel: Player.Event.PlayerItemsDidUpdate.ViewModel)
    func displayPlayerTrackDidUpdate(viewModel: Player.Event.PlayerTrackDidUpdate.ViewModel)
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

    @IBOutlet private weak var carouselView: CarouselView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var trackSlider: UISlider!
    @IBOutlet private weak var remainingTimeLabel: UILabel!
    @IBOutlet private weak var playedTimeLabel: UILabel!

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
        setupCarouselView()
        setupPlayButton()
        setupLeftButton()
        setupRightButton()
        setupCloseButton()
        setupTrackSlider()
        setupRemainingTimeLabel()
        setupPlayedTimeLabel()

        let syncRequest = Event.ViewDidLoadSync.Request()
        sendSync { (interactor) in
            interactor.onViewDidLoadSync(request: syncRequest)
        }

        let request = Event.ViewDidLoad.Request()
        sendAsync { (interactor) in
            interactor.onViewDidLoad(request: request)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let request = Event.ViewWillAppear.Request()
        sendAsync { (interactor) in
            interactor.onViewWillAppear(request: request)
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

    @IBAction func closeButtonAction(_ sender: Any) {

        interactorDispatcher.sync { (interactor) in
            let request = Player.Event.CloseSync.Request()
            interactor.onCloseSync(request: request)
        }
    }

    // MARK: - Private methods

    private func setupView() {
        view.backgroundColor = UIColor.white
    }

    private func setupCarouselView() {
        carouselView.scrollViewDidScroll = { [weak self] in
            self?.sendAsync({ (interactor) in
                let request = Event.DidScrollItemsList.Request()
                interactor.onDidScrollItemsList(request: request)
            })
        }

        carouselView.didSelectItem = { [weak self] (identifier) in
            self?.sendAsync({ (interactor) in
                let request = Event.DidSelectItem.Request(id: identifier)
                interactor.onDidSelectItem(request: request)
            })
        }
    }

    private func setupPlayedTimeLabel() {
        setupTrackSliderLabel(playedTimeLabel)
    }

    private func setupRemainingTimeLabel() {
        setupTrackSliderLabel(remainingTimeLabel)
    }

    private func setupTrackSliderLabel(_ label: UILabel) {
        label.textAlignment = .center
        label.font = UIFont.sfProText(.bold, ofSize: 9)
        label.textColor = UIColor.fxBombay
    }

    private func setupPlayButton() {
        setupPlayerControlButton(playButton)
    }

    private func setupLeftButton() {
        leftButton.setImage(UIImage.fxJumpBack, for: .normal)
        setupPlayerControlButton(leftButton)
        leftButton.isEnabled = false
    }

    private func setupRightButton() {
        rightButton.setImage(UIImage.fxJumpForward, for: .normal)
        setupPlayerControlButton(rightButton)
        rightButton.isEnabled = false
    }

    private func setupCloseButton() {
        closeButton.setImage(UIImage.fxClose, for: .normal)
        closeButton.contentMode = .scaleAspectFit
        closeButton.tintColor = UIColor.fxBlack
    }

    private func setupPlayerControlButton(_ button: UIButton) {
        button.contentMode = .scaleAspectFit
        button.tintColor = UIColor.fxBlack
    }

    private func setupTrackSlider() {
        trackSlider.minimumTrackTintColor = UIColor.fxDodgerBlue
        trackSlider.maximumTrackTintColor = UIColor.fxMishka
        trackSlider.thumbTintColor = UIColor.fxDodgerBlue
        trackSlider.setThumbImage(UIImage.fxTrackThumb, for: .normal)
        trackSlider.setThumbImage(UIImage.fxTrackThumb, for: .highlighted)
    }

    private func sendSync<Result>(_ block: (Interactor) -> Result) -> Result {
        return self.interactorDispatcher.sync { (interactor) in
            block(interactor)
        }
    }

    private func sendAsync(_ block: @escaping (Interactor) -> Void) {
        self.interactorDispatcher.sync { (interactor) in
            block(interactor)
        }
    }
}

extension Player.ViewControllerImp: Player.ViewController {

    func displayPlayerStateDidUpdate(viewModel: Player.Event.PlayerStateDidUpdate.ViewModel) {
        playButton.setImage(viewModel.playButtonIcon, for: .normal)
    }

    func displayCloseSync(viewModel: Player.Event.CloseSync.ViewModel) {
        output.onClose()
    }

    func displayItemsDidUpdate(viewModel: Player.Event.PlayerItemsDidUpdate.ViewModel) {
        let items = viewModel.items.map { (item) -> CarouselView.Item in
            return CarouselView.Item(imageUrl: item.imageUrl, id: item.identifier)
        }

        carouselView.setItems(items, selectedIndexPath: viewModel.selectedIndexPath)
    }

    func displayPlayerTrackDidUpdate(viewModel: Player.Event.PlayerTrackDidUpdate.ViewModel) {

        playedTimeLabel.text = viewModel.played
        remainingTimeLabel.text = viewModel.remaining
        trackSlider.setValue(viewModel.value, animated: true)
    }
}
