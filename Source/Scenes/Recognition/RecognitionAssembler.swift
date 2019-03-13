import UIKit

// MARK: - Protocol

protocol RecognitionAssembler {
    typealias Output = Recognition.Output

    associatedtype View: Recognition.ViewController

    func assembly(with output: Output) -> View
}

extension Recognition {
    typealias Assembler = RecognitionAssembler

    // MARK: - Declaration

    class AssemblerImp {
        typealias Interactor = Recognition.Interactor
        typealias InteractorImp = Recognition.InteractorImp
        typealias InteractorDispatcher = Recognition.InteractorDispatcher
        typealias PresenterImp = Recognition.PresenterImp
        typealias PresenterDispatcher = Recognition.PresenterDispatcher
        typealias ViewControllerImp = Recognition.ViewControllerImp
    }
}

//MARK: - Assembler

extension Recognition.AssemblerImp: Recognition.Assembler {

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
