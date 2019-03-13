import UIKit

// MARK: - Protocol

protocol RecognitionViewController: class {
    typealias Event = Recognition.Event

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel)
}

// MARK: - Declaration

class RecognitionViewControllerImp: UIViewController {

    // MARK: Typealiases

    typealias Interactor = Recognition.Interactor
    typealias InteractorImp = Recognition.InteractorImp
    typealias InteractorDispatcher = Recognition.InteractorDispatcher
    typealias Presenter = Recognition.Presenter
    typealias PresenterImp = Recognition.PresenterImp
    typealias PresenterDispatcher = Recognition.PresenterDispatcher
    typealias ViewController = Recognition.ViewController
    typealias ViewControllerImp = Recognition.ViewControllerImp
    typealias Output = Recognition.Output
    typealias Assembler = Recognition.Assembler
    typealias AssemplerImp = Recognition.AssemblerImp
    typealias Model = Recognition.Model
    typealias Event = Recognition.Event

    // MARK: Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var recognitionTextLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!

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
}

// MARK: - Private

private extension Recognition.ViewControllerImp {
    func setupUi() {

    }

    func sendViewDidLoadRequest() {
        let request = Event.ViewDidLoad.Request()
        sendAsync { (interactor) in
            interactor.onViewDidLoad(request: request)
        }
    }
}

// MARK: - ViewController

extension Recognition.ViewControllerImp: Recognition.ViewController {

    func displayViewDidLoad(viewModel: Event.ViewDidLoad.ViewModel) {
        titleLabel.text = viewModel.title
    }
}
