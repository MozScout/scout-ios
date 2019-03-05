import UIKit

// MARK: - Protocol

protocol ListenAssembler {
    typealias Output = Listen.Output

    associatedtype View: Listen.ViewController

    func assembly(with output: Output) -> View
}

extension Listen {
    typealias Assembler = ListenAssembler

    // MARK: - Declaration

    class AssemblerImp {

        typealias Interactor = Listen.Interactor
        typealias InteractorImp = Listen.InteractorImp
        typealias InteractorDispatcher = Listen.InteractorDispatcher
        typealias PresenterImp = Listen.PresenterImp
        typealias PresenterDispatcher = Listen.PresenterDispatcher
        typealias ViewControllerImp = Listen.ViewControllerImp

        private let appAssembly: AppAssembly

        init(appAssembly: AppAssembly) {
            self.appAssembly = appAssembly
        }
    }
}

//MARK: - Assembler

extension Listen.AssemblerImp: Listen.Assembler {

    func assembly(with output: Output) -> Listen.ViewControllerImp {
        let viewController = ViewControllerImp(output: output)
        let presenterDispatcher = PresenterDispatcher(queue: DispatchQueue.main, recipient: Weak(viewController))
        let presenter = PresenterImp(presenterDispatcher: presenterDispatcher, durationFormatter: Listen.DurationFormatterImp())
        let itemsFetcher = Listen.ItemsWorkerImp(listenApi: appAssembly.assemblyApi().listenListApi)
        let interactor = InteractorImp(presenter: presenter, itemsFetcher: itemsFetcher)
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
