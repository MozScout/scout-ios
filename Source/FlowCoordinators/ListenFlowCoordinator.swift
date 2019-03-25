//
//  ListenFlowCoordinator.swift
//  Scout
//
//

import UIKit

class ListenFlowCoordinator: BaseFlowCoordinator {

    typealias ShowClosure = (_ content: UIViewController, _ animated: Bool) -> Void

    private let assembly: Assembly
    private let onShowPlayer: () -> Void
    private let onHandsFree: () -> Void

    private lazy var navigationController: UINavigationController = {
        let navigation = UINavigationController()
        navigation.setNavigationBarHidden(true, animated: false)

        let navigationBarController = createNavigationBarController(with: createListScene())
        navigationBarController.definesPresentationContext = true

        navigation.setViewControllers([navigationBarController], animated: false)

        return navigation
    }()

    init(
        rootNavigation: RootNavigationProtocol,
        assembly: Assembly,
        onShowPlayer: @escaping () -> Void,
        onHandsFree: @escaping () -> Void
        ) {

        self.assembly = assembly
        self.onShowPlayer = onShowPlayer
        self.onHandsFree = onHandsFree

        super.init(rootNavigation: rootNavigation)
    }

    func showListenScene(show: ShowClosure, animated: Bool) {
        show(navigationController, animated)
    }

    func showSearchScene(show: ShowClosure, parent: UIViewController?, animated: Bool) {
        let scene = createSearchScene(with: parent)
        let navigationBarController = createNavigationBarController(with: scene)
        navigationBarController.modalPresentationStyle = .overCurrentContext

        show(navigationBarController, animated)
    }

    private func createListScene() -> Listen.ViewControllerImp {
        let output = Listen.Output(
            onShowPlayer: { [weak self] in
                self?.onShowPlayer()
            }, onHandsFree: { [weak self] in
                self?.onHandsFree()
            }, onBack: { },
               onSearch: { [weak self] in
                self?.runSearchScene()
            }
        )

        return assembly.assemblyListenList(output: output)
    }

    private func createSearchScene(with parent: UIViewController?) -> Listen.ViewControllerImp {
        let output = Listen.Output(
            onShowPlayer: { [weak self] in
                self?.onShowPlayer()
            }, onHandsFree: { },
               onBack: {
                parent?.dismiss(animated: true, completion: nil)
            },
               onSearch: { }
        )

        return assembly.assemblyListenSearch(output: output)
    }

    private func createNavigationBarController(with scene: NavigationBarContainerController.ContentController) -> UIViewController {
        let navigationBarController = NavigationBarContainerController()
        _ = navigationBarController.view
        navigationBarController.setContent(scene)
        return navigationBarController
    }

    private func runSearchScene() {
        let scene = createSearchScene(with: navigationController.topViewController)

        let navigationBarController = createNavigationBarController(with: scene)
        navigationBarController.modalPresentationStyle = .overCurrentContext

        navigationController.topViewController?.present(navigationBarController, animated: true, completion: nil)
    }
}

extension ListenFlowCoordinator {

    class Assembly {

        private let appAssembly: AppAssembly

        init(appAssembly: AppAssembly) {

            self.appAssembly = appAssembly
        }

        func assemblyListenList(output: Listen.Output) -> Listen.ViewControllerImp {
            let assembler = Listen.ListAssembler(appAssembly: appAssembly)
            return assembler.assembly(with: output)
        }

        func assemblyListenSearch(output: Listen.Output) -> Listen.ViewControllerImp {
            let assembler = Listen.SearchAssembler(appAssembly: appAssembly)
            return assembler.assembly(with: output)
        }
    }
}

