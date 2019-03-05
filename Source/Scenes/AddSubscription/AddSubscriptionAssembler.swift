import UIKit

// MARK: - Protocol

protocol AddSubscriptionAssembler {
    typealias Output = AddSubscription.Output

    associatedtype View: AddSubscription.ViewController

    func assembly(with output: Output) -> View
}

extension AddSubscription {
    typealias Assembler = AddSubscriptionAssembler

    // MARK: - Declaration

    class AssemblerImp {
        typealias Interactor = AddSubscription.Interactor
        typealias InteractorImp = AddSubscription.InteractorImp
        typealias InteractorDispatcher = AddSubscription.InteractorDispatcher
        typealias PresenterImp = AddSubscription.PresenterImp
        typealias PresenterDispatcher = AddSubscription.PresenterDispatcher
        typealias ViewControllerImp = AddSubscription.ViewControllerImp
    }
}

//MARK: - Assembler

extension AddSubscription.AssemblerImp: AddSubscription.Assembler {

    func assembly(with output: Output) -> ViewControllerImp {
        let viewController = ViewControllerImp(output: output)
        let presenterDispatcher = PresenterDispatcher(queue: DispatchQueue.main, recipient: Weak(viewController))
        let presenter = PresenterImp(presenterDispatcher: presenterDispatcher)
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
