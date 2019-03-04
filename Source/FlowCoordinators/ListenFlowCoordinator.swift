//
//  ListenFlowCoordinator.swift
//  Scout
//
//

import UIKit

class ListenFlowCoordinator: BaseFlowCoordinator {

    typealias ShowClosure = (_ content: UIViewController, _ animated: Bool) -> Void

    private let assembly: Assembly
    private let loadingOverlayViewController: LoadingOverlayViewController = LoadingOverlayViewController()
    private let show: ShowClosure

    private lazy var navigationController: UINavigationController = {
        let navigation = UINavigationController()
        navigation.setNavigationBarHidden(true, animated: false)
//
//        let navigationBarController = createController()
//
//        navigation.setViewControllers([navigationBarController], animated: false)

        navigation.setViewControllers([createScene()], animated: false)

        return navigation
    }()

    init(
        rootNavigation: RootNavigationProtocol,
        assembly: Assembly,
        show: @escaping ShowClosure
        ) {

        self.assembly = assembly
        self.show = show

        loadingOverlayViewController.modalPresentationStyle = .overCurrentContext

        super.init(rootNavigation: rootNavigation)
    }

    func showContent(animated: Bool) {
        show(navigationController, animated)
    }

    func showLoading() {
        loadingOverlayViewController.startLoading()
        rootNavigation.presentController(loadingOverlayViewController, animated: false, completion: nil)
    }

    func hideLoading() {
        loadingOverlayViewController.dismiss(animated: false, completion: nil)
        loadingOverlayViewController.stopLoading()
    }

    private func createScene() -> UIViewController {
        let output = Listen.Output.init(
            onShowLoading: { [weak self] in
                self?.showLoading()
            },
            onHideLoading: { [weak self] in
                self?.hideLoading()
            }
        )

        return assembly.assemblyListen(output: output)
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

