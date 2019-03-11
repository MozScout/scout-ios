//
//  ListenFlowCoordinator.swift
//  Scout
//
//

import UIKit

class ListenFlowCoordinator: BaseFlowCoordinator {

    typealias ShowClosure = (_ content: UIViewController, _ animated: Bool) -> Void

    private let assembly: Assembly
    private let show: ShowClosure

    private lazy var navigationController: UINavigationController = {
        let navigation = UINavigationController()
        navigation.setNavigationBarHidden(true, animated: false)

        let navigationBarController = createController()

        navigation.setViewControllers([navigationBarController], animated: false)

        return navigation
    }()

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
        show(navigationController, animated)
    }

    private func createScene() -> Listen.ViewControllerImp {
        let output = Listen.Output.init()

        return assembly.assemblyListen(output: output)
    }

    private func createController() -> UIViewController {
        let navigationBarController = NavigationBarContainerController()
        _ = navigationBarController.view
        navigationBarController.setContent(createScene())
        return navigationBarController
    }
}

extension ListenFlowCoordinator {

    class Assembly {

        private let appAssembly: AppAssembly

        init(appAssembly: AppAssembly) {

            self.appAssembly = appAssembly
        }

        func assemblyListen(output: Listen.Output) -> Listen.ViewControllerImp {
            let assembler = Listen.AssemblerImp(appAssembly: appAssembly)
            return assembler.assembly(with: output)
        }
    }
}

