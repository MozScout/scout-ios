import UIKit

// MARK: - Protocol

protocol PlayerAssembler {
    typealias Output = Player.Output

    associatedtype View: Player.ViewController

    func assembly(with output: Output) -> View
}

extension Player {
    typealias Assembler = PlayerAssembler

    // MARK: - Declaration

    class AssemblerImp {
        typealias Interactor = Player.Interactor
        typealias InteractorImp = Player.InteractorImp
        typealias InteractorDispatcher = Player.InteractorDispatcher
        typealias PresenterImp = Player.PresenterImp
        typealias PresenterDispatcher = Player.PresenterDispatcher
        typealias ViewControllerImp = Player.ViewControllerImp

        private let appAssembly: AppAssembly

        init(
            appAssembly: AppAssembly
            ) {

            self.appAssembly = appAssembly
        }
    }
}

//MARK: - Assembler

extension Player.AssemblerImp: Player.Assembler {

    func assembly(with output: Output) -> ViewControllerImp {

        let viewController = ViewControllerImp(output: output)
        let presenterDispatcher = PresenterDispatcher(queue: DispatchQueue.main, recipient: Weak(viewController))
        let presenter = PresenterImp(presenterDispatcher: presenterDispatcher)

        let itemProvider = Player.ItemProviderImp(
            itemsProvider: appAssembly.assemblyPlayerItemsProvider(),
            audioLoader: appAssembly.assemblyPlayerAudioLoader()
        )

        let interactor = InteractorImp(
            presenter: presenter,
            playerManager: appAssembly.assemblyPlayerCoordinator(),
            itemProvider: itemProvider
        )
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
