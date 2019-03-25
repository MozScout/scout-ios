import UIKit

// MARK: - Protocol

protocol SubscriptionsAssembler {
    typealias Output = Subscriptions.Output

    associatedtype View: Subscriptions.ViewController

    func assembly(with output: Output) -> View
}

extension Subscriptions {
    typealias Assembler = SubscriptionsAssembler

    // MARK: - Declaration

    class AssemblerImp {
        typealias Interactor = Subscriptions.Interactor
        typealias InteractorImp = Subscriptions.InteractorImp
        typealias InteractorDispatcher = Subscriptions.InteractorDispatcher
        typealias PresenterImp = Subscriptions.PresenterImp
        typealias PresenterDispatcher = Subscriptions.PresenterDispatcher
        typealias ViewControllerImp = Subscriptions.ViewControllerImp
    }
}

//MARK: - Assembler

extension Subscriptions.AssemblerImp: Subscriptions.Assembler {

    func assembly(with output: Output) -> ViewControllerImp {
        let viewController = ViewControllerImp(output: output)
        let presenterDispatcher = PresenterDispatcher(queue: DispatchQueue.main, recipient: Weak(viewController))
        let dateFormatter = Subscriptions.DateFormatterImp()
        let presenter = PresenterImp(
            presenterDispatcher: presenterDispatcher,
            dateFormatter: dateFormatter
        )
        let interactor = InteractorImp(presenter: presenter)
        let interactorDispatcher = InteractorDispatcher(
            queue: DispatchQueue(
                label: "\(NSStringFromClass(InteractorDispatcher.self))\(Interactor.self)".queueLabel,
                qos: .userInteractive
            ),
            recipient: interactor
        )

        viewController.inject(interactorDispatcher: interactorDispatcher)
        return viewController
    }
}
