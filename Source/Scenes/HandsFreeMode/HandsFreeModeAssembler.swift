import UIKit

// MARK: - Protocol

protocol HandsFreeModeAssembler {
    typealias Output = HandsFreeMode.Output

    associatedtype View: HandsFreeMode.ViewController

    func assembly(with output: Output) -> View
}

extension HandsFreeMode {

    typealias Assembler = HandsFreeModeAssembler

    // MARK: - Declaration

    class AssemblerImp {

        typealias Interactor = HandsFreeMode.Interactor
        typealias InteractorImp = HandsFreeMode.InteractorImp
        typealias InteractorDispatcher = HandsFreeMode.InteractorDispatcher
        typealias PresenterImp = HandsFreeMode.PresenterImp
        typealias PresenterDispatcher = HandsFreeMode.PresenterDispatcher
        typealias ViewControllerImp = HandsFreeMode.ViewControllerImp

        private let appAssembly: AppAssembly

        init(appAssembly: AppAssembly) {
            self.appAssembly = appAssembly
        }
    }
}

//MARK: - Assembler

extension HandsFreeMode.AssemblerImp: HandsFreeMode.Assembler {

    func assembly(with output: Output) -> ViewControllerImp {
        let viewController = ViewControllerImp(output: output)
        let presenterDispatcher = PresenterDispatcher(queue: DispatchQueue.main, recipient: Weak(viewController))
        let presenter = PresenterImp(presenterDispatcher: presenterDispatcher)
        let handsFreeService = appAssembly.assemblyHandsFreeService()
        let interactor = InteractorImp(presenter: presenter, handsFreeService: handsFreeService)
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
