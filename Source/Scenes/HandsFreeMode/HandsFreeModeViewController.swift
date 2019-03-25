import UIKit

// MARK: - Protocol

protocol HandsFreeModeViewController: class {

    typealias Event = HandsFreeMode.Event

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel)
    func displayModeDidSwitched(viewModel: Event.ModeDidSwitched.ViewModel)
}

// MARK: - Declaration

class HandsFreeModeViewControllerImp: UIViewController {

    // MARK: Typealiases

    typealias Interactor = HandsFreeMode.Interactor
    typealias InteractorImp = HandsFreeMode.InteractorImp
    typealias InteractorDispatcher = HandsFreeMode.InteractorDispatcher
    typealias Presenter = HandsFreeMode.Presenter
    typealias PresenterImp = HandsFreeMode.PresenterImp
    typealias PresenterDispatcher = HandsFreeMode.PresenterDispatcher
    typealias ViewController = HandsFreeMode.ViewController
    typealias ViewControllerImp = HandsFreeMode.ViewControllerImp
    typealias Output = HandsFreeMode.Output
    typealias Assembler = HandsFreeMode.Assembler
    typealias AssemplerImp = HandsFreeMode.AssemblerImp
    typealias Model = HandsFreeMode.Model
    typealias Event = HandsFreeMode.Event

    // MARK: Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var handsFreeSwitch: UISwitch!
    @IBOutlet private weak var switchTitleLabel: UILabel!

    // MARK: Private Properties

    private let output: Output
    private var interactorDispatcher: InteractorDispatcher!

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

        setupUi()
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

    // MARK: Actions

    @IBAction func cancelAction(_ sender: Any) {
        output.onCancelAction()
    }

    @IBAction func switchAction(_ sender: Any) {
        sendModeDidSwitchedRequest()
    }
}

// MARK: - Private

private extension HandsFreeMode.ViewControllerImp {
    func setupUi() {

    }

    func sendViewDidLoadRequest() {
        let request = Event.ViewDidLoad.Request()
        sendAsync { (interactor) in
            interactor.onViewDidLoad(request: request)
        }
    }

    func sendModeDidSwitchedRequest() {
        let request = Event.ModeDidSwitched.Request()
        sendAsync { (interactor) in
            interactor.onModeDidSwitched(request: request)
        }
    }
}

// MARK: - ViewController

extension HandsFreeMode.ViewControllerImp: HandsFreeMode.ViewController {

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel) {
        titleLabel.text = viewModel.title
        switchTitleLabel.text = viewModel.switchTitle
        handsFreeSwitch.isOn = viewModel.isHandsFreeModeEnabled
    }

    func displayModeDidSwitched(viewModel: Event.ModeDidSwitched.ViewModel) {
        handsFreeSwitch.isOn = viewModel.isHandsFreeModeEnabled
    }
}
