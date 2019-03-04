import UIKit
import DifferenceKit

// MARK: - Protocol

protocol ListenViewController: class {
    typealias Event = Listen.Event

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel)
    func displayItemsDidUpdate(viewModel: Event.ItemsDidUpdate.ViewModel)
    func displayDidChangeEditing(viewModel: Event.DidChangeEditing.ViewModel)
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
    typealias AssemplerImp = Listen.AssemblerImp
    typealias Model = Listen.Model
    typealias Event = Listen.Event

    // MARK: Outlets

    @IBOutlet private weak var tableView: UITableView!

    // FIXME: - temp ----------------------------------------
    @IBOutlet weak var editButton: UIButton!
    @IBAction func button(_ sender: Any) {
        sendDidChangeEditingRequest()
    }
    // ------------------------------------------------------
    
    // MARK: Private Properties

    private let output: Output
    private var interactorDispatcher: InteractorDispatcher!
    private var itemsViewModels = [ListenTableViewCell.ViewModel]()

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

        setupTableView()
        sendViewDidLoadRequest()
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

    func setupTableView() {
        tableView.register(ListenTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(sendDidRefreshItemsRequest), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    func sendViewDidLoadRequest() {
        interactorDispatcher.async { (interactor) in
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
}

// MARK: - ViewController

extension Listen.ViewControllerImp: Listen.ViewController {

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel) {
        editButton.setTitle(viewModel.editingButtonTitle, for: .normal)
    }

    func displayItemsDidUpdate(viewModel: Event.ItemsDidUpdate.ViewModel) {
        reloadTableView(with: viewModel.items)
    }

    func displayDidChangeEditing(viewModel: Event.DidChangeEditing.ViewModel) {
        editButton.setTitle(viewModel.editingButtonTitle, for: .normal)
        tableView.setEditing(viewModel.isEditing, animated: true)
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
}
