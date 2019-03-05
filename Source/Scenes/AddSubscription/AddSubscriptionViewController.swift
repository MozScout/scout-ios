import UIKit

// MARK: - Protocol

protocol AddSubscriptionViewController: class {
    typealias Event = AddSubscription.Event

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel)
    func displayTopicsDidUpdate(viewModel: Event.TopicsDidUpdate.ViewModel)
}

extension AddSubscription {
    typealias ViewController = AddSubscriptionViewController
    typealias ViewControllerImp = AddSubscriptionViewControllerImp
}

// MARK: - Declaration

class AddSubscriptionViewControllerImp: UIViewController {

    // MARK: Typealiases

    typealias Interactor = AddSubscription.Interactor
    typealias InteractorImp = AddSubscription.InteractorImp
    typealias InteractorDispatcher = AddSubscription.InteractorDispatcher
    typealias Presenter = AddSubscription.Presenter
    typealias PresenterImp = AddSubscription.PresenterImp
    typealias PresenterDispatcher = AddSubscription.PresenterDispatcher
    typealias ViewController = AddSubscription.ViewController
    typealias ViewControllerImp = AddSubscription.ViewControllerImp
    typealias Output = AddSubscription.Output
    typealias Assembler = AddSubscription.Assembler
    typealias AssemplerImp = AddSubscription.AssemblerImp
    typealias Model = AddSubscription.Model
    typealias Event = AddSubscription.Event

    // MARK: Outlets

    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: Private Properties

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
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    private var sectionsViewModels = [Model.SectionViewModel]()

    // MARK: Public Properties

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
        setupCollectionView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let insets = UIEdgeInsets(
            top: topOverlayHeight(view: collectionView),
            left: collectionView.contentInset.left,
            bottom: bottomOverlayHeight(view: collectionView),
            right: collectionView.contentInset.right
        )

        collectionView.contentInset = insets
        collectionView.scrollIndicatorInsets = insets
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

// MARK: - Private

private extension AddSubscription.ViewControllerImp {

    func setupNavigationBar() {
        let navigationBar = SearchNavigationBar.loadFromNib()
        navigationBar.onClose = { [weak self] in
            self?.output.onCancelAction()
        }
        navigationBarContainer?.setNavigationBarContent(navigationBar)
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        let bundle = Bundle(for: RoundTopicCell.self)
        let cellIdentifier = String(describing: RoundTopicCell.self)
        let cellNib = UINib(nibName: cellIdentifier, bundle: bundle)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)

        let headerIdentifier = String(describing: CategorySectionHeaderView.self)
        let headerNib = UINib(nibName: headerIdentifier, bundle: bundle)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
}

extension AddSubscription.ViewControllerImp: AddSubscription.ViewController {

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel) {

    }

    func displayTopicsDidUpdate(viewModel: Event.TopicsDidUpdate.ViewModel) {
            sectionsViewModels = viewModel.items
            collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension  AddSubscription.ViewControllerImp: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionsViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionsViewModels[section].topics.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: RoundTopicCell.self), for: indexPath
            ) as? RoundTopicCell else {

                fatalError("Failed cell dequeuing")
        }

        cell.configure(sectionsViewModels[indexPath.section].topics[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            assertionFailure("Unknown kind of view")
            return UICollectionReusableView()
        }

        let headerIdentifier = String(describing: CategorySectionHeaderView.self)
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerIdentifier,
            for: indexPath
            ) as? CategorySectionHeaderView else {
                fatalError("Failed cell dequeuing")
        }

        header.configure(sectionsViewModels[indexPath.section].sectionHeader)
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension  AddSubscription.ViewControllerImp: UICollectionViewDelegateFlowLayout {

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

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

// MARK: - UICollectionViewDelegate
extension AddSubscription.ViewControllerImp: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        sendTopicDidSelectRequest(indexPath: indexPath)
    }
}

// MARK: - NavigationBarContainerContent

extension AddSubscription.ViewControllerImp: NavigationBarContainerContent { }
