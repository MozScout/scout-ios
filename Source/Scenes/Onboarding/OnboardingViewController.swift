import UIKit
import DifferenceKit

// MARK: - Protocol
protocol OnboardingViewController: class, RootContentProtocol {

    // MARK: Typealiases

    typealias Event = Onboarding.Event

    // MARK: Requirements

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel)
    func displayDidSelectTopic(viewModel: Event.DidSelectTopic.ViewModel)
    func displayTopicsDidDownload(viewModel: Event.TopicsDidDownload.ViewModel)
    func displaySubtopicsDidDownload(viewModel: Event.SubtopicsDidDownload.ViewModel)
}

// MARK: - Declaration
class OnboardingViewControllerImp: UIViewController {

    // MARK: Typealiases

    typealias Interactor = Onboarding.Interactor
    typealias InteractorImp = Onboarding.InteractorImp
    typealias InteractorDispatcher = Onboarding.InteractorDispatcher
    typealias Presenter = Onboarding.Presenter
    typealias PresenterImp = Onboarding.PresenterImp
    typealias PresenterDispatcher = Onboarding.PresenterDispatcher
    typealias ViewController = Onboarding.ViewController
    typealias ViewControllerImp = Onboarding.ViewControllerImp
    typealias Output = Onboarding.Output
    typealias Assembler = Onboarding.Assembler
    typealias AssemplerImp = Onboarding.AssemblerImp
    typealias Model = Onboarding.Model
    typealias Event = Onboarding.Event

    //MARK: Outlets

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var headerView: GradientView!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var headerGradientView: GradientView!
    @IBOutlet private weak var headerBarView: GradientView!
    @IBOutlet private weak var startButtonGradienView: GradientView!
    @IBOutlet private weak var startButton: UIButton!

    //MARK: Private Properties

    private let output: Output
    private var interactorDispatcher: InteractorDispatcher!

    private let itemPerLine = 3
    private let spaceBetweenIntems: CGFloat = 10
    private let lineSpacing: CGFloat = 10
    private var itemSize: CGSize {
        let insentsSpace: CGFloat = sectionInset.left + sectionInset.right
        let totalSpaceBetweenIntems: CGFloat = spaceBetweenIntems * CGFloat(itemPerLine - 1)
        let totalWidth = view.frame.width - insentsSpace - totalSpaceBetweenIntems - CGFloat(itemPerLine)
        let width = totalWidth / CGFloat(itemPerLine)
        return CGSize(width: width, height: width + 33)
    }

    private var sectionInset: UIEdgeInsets {
        return UIEdgeInsets(top: 80, left: 10, bottom: 80, right: 10)
    }

    private var topicsViewModels = [OnboardingCollectionViewCell.ViewModel]()

    //MARK: Initializing

    init(output: Output) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Injections

    func inject(interactorDispatcher: InteractorDispatcher) {
        self.interactorDispatcher = interactorDispatcher
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUi()
        setupCollectionView()
        sendViewDidLoadRequest()
    }

    // MARK: Actions

    @IBAction func startAction(_ sender: Any) {

    }
}

// MARK: - Private
private extension Onboarding.ViewControllerImp {

    func setupUi() {
        headerView.backgroundColor = UIColor.clear

        if !UIAccessibility.isReduceTransparencyEnabled {
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = headerView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            headerView.insertSubview(blurEffectView, at: 0)
        }

        headerGradientView.gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor(white: 1, alpha: 0.8).cgColor,
            UIColor(white: 1, alpha: 0.5).cgColor,
            UIColor(white: 1, alpha: 0).cgColor
        ]
        headerGradientView.gradientLayer.locations = [
            0.05,
            0.3,
            0.6,
            1
        ]

        headerTitleLabel.font = UIFont.sfProText(.bold, ofSize: 16)
        headerTitleLabel.textColor = UIColor.black

        headerBarView.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        headerBarView.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        headerBarView.gradientLayer.colors = [UIColor.fxRadicalRed.cgColor, UIColor.fxYellowOrange.cgColor]

        startButtonGradienView.backgroundColor = UIColor.clear
        startButtonGradienView.gradientLayer.colors = [UIColor(white: 1, alpha: 0).cgColor, UIColor.white.cgColor]
        startButtonGradienView.gradientLayer.locations = [0, 0.2]

        startButton.backgroundColor = UIColor.fxScienceBlue
        startButton.layer.cornerRadius = 8
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.titleLabel?.font = UIFont.sfProDisplay(.bold, ofSize: 21)
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        let bundle = Bundle(for: OnboardingCollectionViewCell.self)
        let identifier = String(describing: OnboardingCollectionViewCell.self)
        let nib = UINib(nibName: identifier, bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    func sendViewDidLoadRequest() {
        let request = Event.ViewDidLoad.Request()
        interactorDispatcher.async { (interactor) in
            interactor.onViewDidLoad(request: request)
        }
    }

    func sendTopicDidSelectRequest(indexPath: IndexPath) {
        let topicId = topicsViewModels[indexPath.row].topicId
        let request = Event.DidSelectTopic.Request(topicId: topicId)
        interactorDispatcher.async { (interactor) in
            interactor.onSelectTopic(request: request)
        }
    }

    func sendStartButtonDidPressRequest() {
        let request = Event.StartButtonDidPress.Request()
        interactorDispatcher.async { (interactor) in
            interactor.onStartButtonDidPress(request: request)
        }
    }
}

// MARK: - ViewController
extension Onboarding.ViewControllerImp: Onboarding.ViewController {
    func getRootContentViewController() -> UIViewController {
        return self
    }

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel) {
        headerTitleLabel.text = viewModel.headerTitle
        startButton.setTitle(viewModel.buttonTitle, for: .normal)
        startButtonGradienView.isHidden = true
        startButtonGradienView.alpha = 0
    }

    func displayDidSelectTopic(viewModel: Event.DidSelectTopic.ViewModel) {
        collectionView.reload(using: StagedChangeset(source: topicsViewModels, target: viewModel.topics)) {
            self.topicsViewModels = $0
        }

        let startButtonFadeAnimationDuration: TimeInterval = 0.2

        if viewModel.isStartEnabled {
            startButtonGradienView.fadeOut(duration: startButtonFadeAnimationDuration)
        } else {
            startButtonGradienView.fadeIn(duration: startButtonFadeAnimationDuration)
        }
    }

    func displayTopicsDidDownload(viewModel: Event.TopicsDidDownload.ViewModel) {
        collectionView.reload(using: StagedChangeset(source: topicsViewModels, target: viewModel.topics)) {
            self.topicsViewModels = $0
        }
    }

    func displaySubtopicsDidDownload(viewModel: Event.SubtopicsDidDownload.ViewModel) {
        collectionView.reload(using: StagedChangeset(source: topicsViewModels, target: viewModel.topics)) {
            self.topicsViewModels = $0
        }
    }
}

// MARK: - UICollectionViewDataSource
extension  Onboarding.ViewControllerImp: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topicsViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: OnboardingCollectionViewCell.self), for: indexPath
            ) as? OnboardingCollectionViewCell else {

                fatalError("Failed cell dequeuing")
        }
        
        cell.configure(topicsViewModels[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension  Onboarding.ViewControllerImp: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {

        return itemSize
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
        ) -> UIEdgeInsets {

        return sectionInset
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
        ) -> CGFloat {

        return lineSpacing
    }
}

// MARK: - UICollectionViewDelegate
extension Onboarding.ViewControllerImp: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sendTopicDidSelectRequest(indexPath: indexPath)
    }
}
