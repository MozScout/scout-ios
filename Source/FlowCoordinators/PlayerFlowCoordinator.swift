//
//  PlayerFlowCoordinator.swift
//  Scout
//
//

import UIKit

class PlayerFlowCoordinator: BaseFlowCoordinator {

    typealias ShowClosure = (_ content: UIViewController, _ animated: Bool) -> Void

    private let assembly: Assembly
    private let show: ShowClosure

    private lazy var player: PlayerViewControllerImp = createPlayer()

    init(
        rootNavigation: RootNavigationProtocol,
        assembly: Assembly,
        show: @escaping ShowClosure
        ) {

        self.assembly = assembly
        self.show = show

        super.init(rootNavigation: rootNavigation)
    }

    func showContent(animated: Bool) {
        show(player, animated)
    }

    private func createPlayer() -> PlayerViewControllerImp {
        let output = Player.Output()
        return assembly.assemblyPlayer(output: output)
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
