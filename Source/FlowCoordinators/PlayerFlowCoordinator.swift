//
//  PlayerFlowCoordinator.swift
//  Scout
//
//

import UIKit

class PlayerFlowCoordinator: BaseFlowCoordinator {

    typealias ShowClosure = (_ content: UIViewController, _ animated: Bool) -> Void
    typealias HideClosure = (_ content: UIViewController, _ animated: Bool) -> Void

    private let assembly: Assembly
    private let show: ShowClosure
    private let hide: HideClosure

    private lazy var player: PlayerViewControllerImp = createPlayer()
    private lazy var playerPartScreenContainer: PartScreenContainerViewController = createPlayerPartScreenContainer()

    init(
        rootNavigation: RootNavigationProtocol,
        assembly: Assembly,
        show: @escaping ShowClosure,
        hide: @escaping HideClosure
        ) {

        self.assembly = assembly
        self.show = show
        self.hide = hide

        super.init(rootNavigation: rootNavigation)
    }

    func showContent(animated: Bool) {
        show(playerPartScreenContainer, animated)
    }

    private func createPlayer() -> PlayerViewControllerImp {
        let output = Player.Output(onClose: { [weak self] in
            self?.onHide()
        })
        return assembly.assemblyPlayer(output: output)
    }

    private func createPlayerPartScreenContainer() -> PartScreenContainerViewController {
        let container = PartScreenContainerViewController()
        container.setContent(player)
        container.onDismiss = { [weak self] in
            self?.onHide()
        }
        return container
    }

    private func onHide() {
        hide(player, true)
    }
}

extension PlayerFlowCoordinator {

    class Assembly {

        private let appAssembly: AppAssembly

        init(appAssembly: AppAssembly) {

            self.appAssembly = appAssembly
        }

        func assemblyPlayer(output: Player.Output) -> Player.ViewControllerImp {
            let assembler = Player.AssemblerImp(
                appAssembly: appAssembly
            )
            return assembler.assembly(with: output)
        }
    }
}
