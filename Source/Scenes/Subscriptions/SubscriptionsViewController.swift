import UIKit

// MARK: - Protocol

protocol SubscriptionsViewController: class {
    typealias Event = Subscriptions.Event

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel)
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

//            let request = Event.ViewDidLoad.Request()
//            sendAsync { (interactor) in
//                interactor.onViewDidLoad(request: request)
//            }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let topOverlay = topOverlayHeight(view: emptyView)
        let bottomOverlay = bottomOverlayHeight(view: emptyView)

        if topOverlay != emptyViewTopConstraint.constant {
            emptyViewTopConstraint.constant += topOverlay
        }
        if bottomOverlay != emptyViewBottomConstraint.constant {
            emptyViewBottomConstraint.constant += bottomOverlay
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

    @objc private func addButtonAction() { }

    private func setupNavigationBar() {
        navigationBarContainer?.setNavigationBarContent(navigationBar)
        navigationBar.setRightItem(addButton)
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
    }

    private func setupEmptyView() {
        emptyView.title = "Add your first podcast."
    }
}


extension Subscriptions {

    typealias ViewController = SubscriptionsViewController
    typealias ViewControllerImp = SubscriptionsViewControllerImp

    // MARK: - Declaration
}

extension Subscriptions.ViewControllerImp: NavigationBarContainerContent { }

extension Subscriptions.ViewControllerImp: Subscriptions.ViewController {

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel) {
        
    }
}
