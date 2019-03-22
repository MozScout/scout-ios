import UIKit

// MARK: - Protocol

protocol SubscriptionsViewController: class {

    func displayViewDidLoad(viewModel: Subscriptions.Event.ViewDidLoad.ViewModel)
    func displaySectionsDidUpdate(viewModel: Subscriptions.Event.SectionsDidUpdate.ViewModel)
    func displayRefreshDidFinish(viewModel: Subscriptions.Event.RefreshDidFinish.ViewModel)
}

class SubscriptionsViewControllerImp: UIViewController {

    typealias Model = Subscriptions.Model
    typealias Event = Subscriptions.Event

    typealias Interactor = Subscriptions.Interactor
    typealias InteractorDispatcher = Subscriptions.InteractorDispatcher
    typealias Output = Subscriptions.Output

    // MARK: Private Properties

    private let output: Output
    private var interactorDispatcher: InteractorDispatcher!

    private let navigationBar: DefaultNavigationBar = DefaultNavigationBar.loadFromNib()

    @IBOutlet private weak var emptyView: SubscriptionsEmptyView!
    @IBOutlet private weak var emptyViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var emptyViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!

    private let refreshControl: UIRefreshControl = UIRefreshControl()

    private var sections: [Subscriptions.Model.SectionViewModel] = []

    private let addButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = UIFont.openSans(ofSize: 14)
        button.setTitleColor(UIColor.fxScienceBlue, for: .normal)
        return button
    }()

    // MARK: Public properties

    var onScrollViewDidScroll: OnScrollViewDidScroll?

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

        setupNavigationBar()
        setupEmptyView()
        setupRefreshControl()
        setupCollectionView()
        setupCollectionViewLayout()

        let request = Event.ViewDidLoad.Request()
        sendAsync { (interactor) in
            interactor.onViewDidLoad(request: request)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let emptyViewTopOverlay = topOverlayHeight(view: emptyView)
        let emptyViewBottomOverlay = bottomOverlayHeight(view: emptyView)

        if emptyViewTopOverlay != emptyViewTopConstraint.constant {
            emptyViewTopConstraint.constant += emptyViewTopOverlay
        }
        if emptyViewBottomOverlay != emptyViewBottomConstraint.constant {
            emptyViewBottomConstraint.constant += emptyViewBottomOverlay
        }

        collectionViewLayout.itemSize = CGSize(
            width: collectionView.bounds.width,
            height: 220
        )

        let collectionViewTopOverlayHeight = topOverlayHeight(view: collectionView)
        let collectionViewBottomOverlayHeight = bottomOverlayHeight(view: collectionView)
        let insets = UIEdgeInsets(
            top: collectionViewTopOverlayHeight,
            left: 0,
            bottom: collectionViewBottomOverlayHeight,
            right: 0
        )
        collectionView.contentInset = insets
        collectionView.scrollIndicatorInsets = insets

        collectionViewLayout.headerReferenceSize = CGSize(
            width: collectionView.bounds.width,
            height: 30
        )
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

    @objc private func addButtonAction() {
        output.onAddAction()
    }

    private func setupNavigationBar() {
        navigationBarContainer?.setNavigationBarContent(navigationBar)
        navigationBar.setRightItem(addButton)
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
    }

    private func setupEmptyView() {
        emptyView.title = "Add your first podcast."
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
    }

    @objc private func refreshControlValueChanged() {
        sendAsync { (interactor) in
            let request = Event.RefreshDidStart.Request()
            interactor.onRefreshDidStart(request: request)
        }
    }

    private func setupCollectionView() {
        setupCollectionViewLayout()

        collectionView.backgroundColor = UIColor.clear
        collectionView.refreshControl = refreshControl
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.alwaysBounceHorizontal = false
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = false

        collectionView.register(classes: [SubscriptionsGroupCell.ViewModel.self])
        collectionView.register(classes: [SubscriptionsHeaderSupplementaryView.ViewModel.self])
    }

    private func setupCollectionViewLayout() {
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.sectionInset = .zero
    }

    private func item(for indexPath: IndexPath) -> SubscriptionsGroupCell.ViewModel {
        return sections[indexPath.section].viewModels[indexPath.item]
    }
}


extension Subscriptions {

    typealias ViewController = SubscriptionsViewController
    typealias ViewControllerImp = SubscriptionsViewControllerImp

    // MARK: - Declaration
}

// MARK: - UICollectionViewDataSource

extension Subscriptions.ViewControllerImp: UICollectionViewDataSource {
    func numberOfSections(
        in collectionView: UICollectionView
        ) -> Int {

        return sections.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {

        return sections[section].viewModels.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {

        return collectionView.dequeueReusableCell(
            with: item(for: indexPath),
            for: indexPath
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
        ) -> UICollectionReusableView {


        if kind == UICollectionView.elementKindSectionHeader {
            let model = sections[indexPath.section].titleModel
            let view = collectionView.dequeueReusableSupplementaryView(
                with: model,
                for: indexPath
            )

            if let header = view as? SubscriptionsHeaderSupplementaryView.View {
                header.onMoreButtonTap = { [weak self] in
                    // FIXME: - Implement event sending
                }
            }

            return view
        } else if kind == UICollectionView.elementKindSectionFooter {
            return UICollectionReusableView()
        } else {
            print(.fatalError(error: "Unknown supplementary view kind: \(kind)"))
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension Subscriptions.ViewControllerImp: UICollectionViewDelegate { }

extension Subscriptions.ViewControllerImp: NavigationBarContainerContent { }

extension Subscriptions.ViewControllerImp: Subscriptions.ViewController {

    func displayViewDidLoad(viewModel: Subscriptions.Event.ViewDidLoad.ViewModel) {
        
    }

    func displaySectionsDidUpdate(viewModel: Subscriptions.Event.SectionsDidUpdate.ViewModel) {
        switch viewModel {
        case .full(let sections):
            self.sections = sections
            collectionView.reloadData()
            emptyView.isHidden = true
        case .empty:
            self.sections = []
            collectionView.reloadData()
            emptyView.isHidden = false
        }
    }

    func displayRefreshDidFinish(viewModel: Subscriptions.Event.RefreshDidFinish.ViewModel) {

        refreshControl.endRefreshing()
    }
}
