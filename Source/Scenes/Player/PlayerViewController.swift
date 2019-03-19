import UIKit

// MARK: - Protocol

protocol PlayerViewController: class {

    func displayPlayerStateDidUpdate(viewModel: Player.Event.PlayerStateDidUpdate.ViewModel)
    func displayCloseSync(viewModel: Player.Event.CloseSync.ViewModel)
    func displayItemsDidUpdate(viewModel: Player.Event.PlayerItemsDidUpdate.ViewModel)
    func displayPlayerTrackDidUpdate(viewModel: Player.Event.PlayerTrackDidUpdate.ViewModel)
    func displayPlayerTimingsDidUpdate(viewModel: Player.Event.PlayerTimingsDidUpdate.ViewModel)
    func displayPlayerItemDidUpdate(viewModel: Player.Event.PlayerItemDidUpdate.ViewModel)
    func displayDidClickPlayerSpeedButton(viewModel: Player.Event.DidClickPlayerSpeedButton.ViewModel)
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

    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var titleItemContainer: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var carouselView: CarouselView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dislikeButton: UIButton!
    @IBOutlet private weak var dividerView: UIView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var trackSlider: UISlider!
    @IBOutlet private weak var remainingTimeLabel: UILabel!
    @IBOutlet private weak var playedTimeLabel: UILabel!
    @IBOutlet private weak var playerSpeedButton: PlayerTextButton!
    @IBOutlet private weak var noteButton: PlayerIconButton!
    @IBOutlet private weak var summaryButton: PlayerSwitcherButton!

    private lazy var titleItemLabel: UILabel = createTitleItemLabel()
    private lazy var titleItemImageView: UIImageView = createTitleItemImageView()

    private var currentTitleItem: UIView?

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
        setupDetailsLabel()
        setupTitleItemContainer()
        setupTitleLabel()
        setupCarouselView()
        setupPlayButton()
        setupLeftButton()
        setupRightButton()
        setupCloseButton()
        setupLikeButton()
        setupDislikeButton()
        setupDividerView()
        setupTrackSlider()
        setupRemainingTimeLabel()
        setupPlayedTimeLabel()
        setupPlayerSpeedButton()
        setupNoteButton()
        setupSummaryButton()

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
        sendAsync { (interactor) in
            let request = Event.DidTapJumpBackward.Request()
            interactor.onDidTapJumpBackward(request: request)
        }
    }

    @IBAction func rightButtonAction(_ sender: Any) {
        sendAsync { (interactor) in
            let request = Event.DidTapJumpForward.Request()
            interactor.onDidTapJumpForward(request: request)
        }
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

    private func setupDetailsLabel() {
        detailsLabel.textAlignment = .left
        detailsLabel.font = UIFont.sfProText(.regular, ofSize: 10)
        detailsLabel.textColor = UIColor.fxBlack
        detailsLabel.numberOfLines = 2
    }

    private func setupTitleItemContainer() {
        titleItemContainer.backgroundColor = UIColor.clear
    }

    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.sfProText(.semibold, ofSize: 18)
        titleLabel.textColor = UIColor.fxBlack
        titleLabel.numberOfLines = 0
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
    }

    private func setupRightButton() {
        rightButton.setImage(UIImage.fxJumpForward, for: .normal)
        setupPlayerControlButton(rightButton)
    }

    private func setupLikeButton() {
        likeButton.setImage(UIImage.fxLike, for: .normal)
        setupPlayerControlButton(likeButton)
        likeButton.isEnabled = false
    }

    private func setupDislikeButton() {
        dislikeButton.setImage(UIImage.fxDislike, for: .normal)
        setupPlayerControlButton(dislikeButton)
        dislikeButton.isEnabled = false
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

    private func setupDividerView() {
        dividerView.backgroundColor = UIColor.fxMishka
    }

    private func setupTrackSlider() {
        trackSlider.minimumValue = 0
        trackSlider.minimumTrackTintColor = UIColor.fxDodgerBlue
        trackSlider.maximumTrackTintColor = UIColor.fxMishka
        trackSlider.thumbTintColor = UIColor.fxDodgerBlue
        trackSlider.setThumbImage(UIImage.fxTrackThumb, for: .normal)
        trackSlider.setThumbImage(UIImage.fxTrackThumb, for: .highlighted)
        trackSlider.addTarget(self, action: #selector(trackSliderValueChanged(_:)), for: .valueChanged)
        trackSlider.addTarget(self, action: #selector(trackSliderCommitValue(_:)), for: [.touchUpInside, .touchUpOutside])
    }

    @objc private func trackSliderValueChanged(_ slider: UISlider) {
        sendAsync { (interactor) in
            let request = Event.PlayerSliderDidChangeValue.Request(value: slider.value)
            interactor.onPlayerSliderDidChangeValue(request: request)
        }
    }

    @objc private func trackSliderCommitValue(_ slider: UISlider) {
        sendAsync { (interactor) in
            let request = Event.PlayerSliderDidCommitValue.Request(value: slider.value)
            interactor.onPlayerSliderDidCommitValue(request: request)
        }
    }

    private func setupPlayerSpeedButton() {
        playerSpeedButton.title = "Voice Speed"
        playerSpeedButton.onDidTap = { [weak self] in
            self?.sendAsync({ (interactor) in
                let request = Event.DidClickPlayerSpeedButton.Request()
                interactor.onDidClickPlayerSpeedButton(request: request)
            })
        }
    }

    private func setupNoteButton() {
        noteButton.title = "Make a Note"
        noteButton.icon = UIImage.fxNote
        noteButton.isEnabled = false
        noteButton.onDidTap = {
            print(.log(message: "Note button click"))
        }
    }

    private func setupSummaryButton() {
        summaryButton.title = "Summarize"
        summaryButton.isEnabled = false
        summaryButton.onDidTap = { [weak summaryButton] in
            summaryButton?.isOn = !(summaryButton?.isOn ?? false)
            print(.log(message: "Summary button click"))
        }
    }

    private func createTitleItemLabel() -> UILabel {
        let label = UILabel()

        label.font = UIFont.sfCompactText(.bold, ofSize: 12)
        label.textColor = UIColor.fxBlack
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }

    private func createTitleItemImageView() -> UIImageView {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(24)
        }

        return imageView
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

        trackSlider.setValue(viewModel.value, animated: true)
    }

    func displayPlayerTimingsDidUpdate(viewModel: Player.Event.PlayerTimingsDidUpdate.ViewModel) {

        playedTimeLabel.text = viewModel.played
        remainingTimeLabel.text = viewModel.remaining
    }

    func displayPlayerItemDidUpdate(viewModel: Player.Event.PlayerItemDidUpdate.ViewModel) {

        trackSlider.maximumValue = viewModel.sliderMaximumValue

        switch viewModel.titleItem {

        case .none:
            currentTitleItem = nil

        case .some(let some):
            switch some {

            case .title(let string):
                titleItemLabel.text = string
                currentTitleItem = titleItemLabel

            case .icon(let url):
                titleItemImageView.kf.setImage(with: url, placeholder: UIImage.fxPlaceholder, options: [.backgroundDecode])
                currentTitleItem = titleItemImageView

            }
        }

        if let titleItem = currentTitleItem {
            titleItemContainer.addSubview(titleItem)
            titleItem.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        } else {
            currentTitleItem?.removeFromSuperview()
        }

        detailsLabel.text = viewModel.details
        titleLabel.attributedText = viewModel.title
    }

    func displayDidClickPlayerSpeedButton(viewModel: Player.Event.DidClickPlayerSpeedButton.ViewModel) {

        playerSpeedButton.value = viewModel.speedButtonValue
    }
}
