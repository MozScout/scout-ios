//
//  SubscriptionsFlowCoordinator.swift
//  Scout
//
//

import UIKit

class SubscriptionsFlowCoordinator: BaseFlowCoordinator {

    typealias ShowClosure = (_ content: UIViewController, _ animated: Bool) -> Void

    private let assembly: Assembly

    private lazy var navigationController: UINavigationController = createNavigationController()

    private let show: ShowClosure

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

    private func createNavigationController() -> UINavigationController {
        let navigation = UINavigationController()
        navigation.setNavigationBarHidden(true, animated: false)

        let startController = createStartController()
        navigation.setViewControllers([startController], animated: false)

        return navigation
    }

    private func createStartController() -> UIViewController {
        return createSubscriptionsScene()
    }

    private func createSubscriptionsScene() -> UIViewController {
        let output = Subscriptions.Output(
            onAddAction: { [weak self] in
                self?.runAddSubscriptionScene()
            }
        )
        let subscriptions = assembly.assemblySubscriptions(output: output)

        let navigationBarController = createNavigationBarContainer(with: subscriptions)
        navigationBarController.definesPresentationContext = true

        return navigationBarController
    }

    private func createNavigationBarContainer(
        with content: NavigationBarContainerController.ContentController
        ) -> UIViewController {

        let navigationBarController = NavigationBarContainerController()
        _ = navigationBarController.view

        navigationBarController.setContent(content)

        return navigationBarController
    }

    private func runAddSubscriptionScene() {
        let output = AddSubscription.Output(onCancelAction: { [weak self] in
            self?.navigationController.topViewController?.dismiss(animated: true, completion: nil)
        })
        let scene = assembly.assemblyAddSubscription(output: output)

        let navigationBarController = createNavigationBarContainer(with: scene)
        navigationBarController.modalPresentationStyle = .overCurrentContext

        navigationController.topViewController?.present(navigationBarController, animated: true, completion: nil)
    }
}

extension SubscriptionsFlowCoordinator {

    class Assembly {

        let appAssembly: AppAssembly

        init(appAssembly: AppAssembly) {
            self.appAssembly = appAssembly
        }

        func assemblySubscriptions(output: Subscriptions.Output) -> Subscriptions.ViewControllerImp {
            let assembler = Subscriptions.AssemblerImp()
            return assembler.assembly(with: output)
        }

        func assemblyAddSubscription(output: AddSubscription.Output) -> AddSubscription.ViewControllerImp {
            let assembler = AddSubscription.AssemblerImp(appAssembly: appAssembly)
            return assembler.assembly(with: output)
        }
    }
}
