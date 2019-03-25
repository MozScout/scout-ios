import UIKit
import DifferenceKit

// MARK: - Protocol

protocol ListenViewController: class {
    typealias Event = Listen.Event

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel)
    func displayItemsDidUpdate(viewModel: Event.ItemsDidUpdate.ViewModel)
    func displayDidChangeEditing(viewModel: Event.DidChangeEditing.ViewModel)
    func displayDidStartFetching(viewModel: Event.DidStartFetching.ViewModel)
    func displayDidEndFetching(viewModel: Event.DidEndFetching.ViewModel)
}

// MARK: - Declaration

class ListenViewControllerImp: UIViewController {

    // MARK: Typealiases

    typealias Interactor = Listen.Interactor
    typealias InteractorImp = Listen.InteractorImp
    typealias InteractorDispatcher = Listen.InteractorDispatcher
    typealias Presenter = Listen.Presenter
    typealias PresenterImp = Listen.PresenterImp
    typealias PresenterDispatcher = Listen.PresenterDispatcher
    typealias ViewController = Listen.ViewController
    typealias ViewControllerImp = Listen.ViewControllerImp
    typealias Output = Listen.Output
    typealias Assembler = Listen.Assembler
    typealias AssemplerImp = Listen.ListAssembler
    typealias Model = Listen.Model
    typealias Event = Listen.Event

    // MARK: Outlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: Private Properties

    private let output: Output
    private var interactorDispatcher: InteractorDispatcher!
    private var itemsViewModels = [ListenTableViewCell.ViewModel]()
    private let editButton = UIButton(type: .custom)

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

        sendViewDidLoadRequest()
        setupTableView()
        setupUi()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async {
            let insets = UIEdgeInsets(
                top: self.topOverlayHeight(view: self.tableView),
                left: self.tableView.contentInset.left,
                bottom: self.bottomOverlayHeight(view: self.tableView),
                right: self.tableView.contentInset.right
            )

            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
        }
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

private extension Listen.ViewControllerImp {

    func setupUi() {
        editButton.titleLabel?.font = UIFont.openSans(ofSize: 14)
        editButton.setTitleColor(UIColor.fxScienceBlue, for: .normal)
        editButton.addTarget(self, action: #selector(changeEditMode), for: .touchUpInside)
    }

    func setupNavigationBar() {
        navigationBarContainer?.hidesNavigationBarOnScroll = true
        let navigationBar = DefaultNavigationBar.loadFromNib()
        navigationBar.setRightItem(editButton)
        navigationBar.onHandsFreeTap = { [weak self] in
            self?.output.onHandsFree()
        }

        navigationBar.onSearchTap = { [weak self] in
            self?.output.onSearch()
        }

        navigationBarContainer?.setNavigationBarContent(navigationBar)
    }

    func setupSearchBar() {

        let navigationBar = SearchNavigationBar.loadFromNib()
        navigationBar.onClose = { [weak self] in
            self?.output.onBack()
        }
        navigationBarContainer?.setNavigationBarContent(navigationBar)
    }

    func setupTableView() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(ListenTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(sendDidRefreshItemsRequest), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
    }

    func sendViewDidLoadRequest() {
        sendSync { (interactor) in
            interactor.onViewDidLoad(request: Event.ViewDidLoad.Request())
        }
    }

    func sendDidRemoveItemRequest(with itemId: String) {
        interactorDispatcher.async { (interactor) in
            interactor.onDidRemoveItem(request: Event.DidRemoveItem.Request(itemId: itemId))
        }
    }

    func sendDidPressSummaryRequest(with itemId: String) {
        interactorDispatcher.async { (interactor) in
            interactor.onDidPressSummary(request: Event.DidPressSummary.Request(itemId: itemId))
        }
    }

    func sendDidSelectItemRequest(with itemId: String) {
        interactorDispatcher.async { (interactor) in
            interactor.onDidSelectItem(request: Event.DidSelectItem.Request(itemId: itemId))
        }
    }

    func sendDidChangeEditingRequest() {
        interactorDispatcher.async { (interactor) in
            interactor.onDidChangeEditing(request: Event.DidChangeEditing.Request())
        }
    }

    @objc func sendDidRefreshItemsRequest() {
        interactorDispatcher.async { (interactor) in
            interactor.onDidRefreshItems(request: Event.DidRefreshItems.Request())
        }
    }

    func reloadTableView(with items: [ListenTableViewCell.ViewModel]) {
        tableView.reload(using: StagedChangeset(source: itemsViewModels, target: items), with: .automatic) {
            self.itemsViewModels = $0
        }

        tableView.refreshControl?.endRefreshing()
    }

    @objc func changeEditMode() {
        if !tableView.isEditing {
            tableView.endEditing(true)
        }

        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationBarContainer?.hidesNavigationBarOnScroll = !tableView.isEditing
        sendDidChangeEditingRequest()
    }
}

// MARK: - ViewController

extension Listen.ViewControllerImp: Listen.ViewController {

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel) {
        editButton.setTitle(viewModel.editingButtonTitle, for: .normal)
        switch viewModel.mode {
        case .list:
            setupNavigationBar()
        case .search:
            setupSearchBar()
        }
    }

    func displayItemsDidUpdate(viewModel: Event.ItemsDidUpdate.ViewModel) {
        reloadTableView(with: viewModel.items)
    }

    func displayDidChangeEditing(viewModel: Event.DidChangeEditing.ViewModel) {
        editButton.setTitle(viewModel.editingButtonTitle, for: .normal)
        tableView.setEditing(viewModel.isEditing, animated: true)
    }

    func displayDidStartFetching(viewModel: Event.DidStartFetching.ViewModel) {
        view.showLoading()
    }

    func displayDidEndFetching(viewModel: Event.DidEndFetching.ViewModel) {
        view.hideLoading()
    }
}

// MARK: - UITableViewDataSource

extension Listen.ViewControllerImp: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ListenTableViewCell.self, for: indexPath)
        cell.configure(itemsViewModels[indexPath.row])
        cell.onSummaryAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.sendDidPressSummaryRequest(with: strongSelf.itemsViewModels[indexPath.row].itemId)
            self?.output.onShowPlayer()
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension Listen.ViewControllerImp: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendDidSelectItemRequest(with: itemsViewModels[indexPath.row].itemId)
        output.onShowPlayer()
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard itemsViewModels[indexPath.row].summary != nil else {
            return nil
        }

        let action = UIContextualAction(style: .normal, title: "Summary") { (_, _, completion) in
            self.sendDidPressSummaryRequest(with: self.itemsViewModels[indexPath.row].itemId)
            completion(true)
        }
        action.backgroundColor = UIColor.fxAzureRadiance

        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Remove") { (_, _, completion) in
            self.sendDidRemoveItemRequest(with: self.itemsViewModels[indexPath.row].itemId)
            completion(true)
        }
        action.backgroundColor = UIColor.fxTorchRed

        return UISwipeActionsConfiguration(actions: [action])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollViewDidScroll?(scrollView)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Remove") { (_, indexPath) in
            self.sendDidRemoveItemRequest(with: self.itemsViewModels[indexPath.row].itemId)
        }
        action.backgroundColor  = UIColor.fxTorchRed
        
        return [action]
    }
}

// MARK: - NavigationBarContainerContent

extension Listen.ViewControllerImp: NavigationBarContainerContent { }
