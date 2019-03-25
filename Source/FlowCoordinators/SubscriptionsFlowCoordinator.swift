//
//  SubscriptionsFlowCoordinator.swift
//  Scout
//
//

import UIKit

class SubscriptionsFlowCoordinator: BaseFlowCoordinator {

    typealias ShowClosure = (_ content: UIViewController, _ animated: Bool) -> Void

    private let assembly: Assembly
    private let show: ShowClosure
    private let onShowPlayer: () -> Void
    private let onHandsFree: () -> Void

    private lazy var navigationController: UINavigationController = createNavigationController()
    private lazy var listenFlowCoordinator: ListenFlowCoordinator = createListenFlow()

    init(
        rootNavigation: RootNavigationProtocol,
        assembly: Assembly,
        show: @escaping ShowClosure,
        onShowPlayer: @escaping () -> Void,
        onHandsFree: @escaping () -> Void
        ) {

        self.assembly = assembly
        self.show = show
        self.onShowPlayer = onShowPlayer
        self.onHandsFree = onHandsFree

        super.init(rootNavigation: rootNavigation)
    }

    func showContent(animated: Bool) {
        show(navigationController, animated)
    }

    private func createListenFlow() -> ListenFlowCoordinator {
        let assembly = self.assembly.assemblyListenFlowCoordinatorAssembly()

        let flowCoordinator = ListenFlowCoordinator(
            rootNavigation: rootNavigation,
            assembly: assembly,
            onShowPlayer: { [weak self] in
                self?.onShowPlayer()
            }, onHandsFree: { [weak self] in
                self?.onHandsFree()
            }
        )

        return flowCoordinator
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
            }, onHandsFree: { [weak self] in
                self?.onHandsFree()
            }, onSearch: {  [weak self] in
                self?.listenFlowCoordinator.showSearchScene(show: { [weak self] (scene, animated) in
                    self?.navigationController.topViewController?.present(scene, animated: true, completion: nil)
                    }, parent: self?.navigationController.topViewController, animated: true)
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

        func assemblyListenFlowCoordinatorAssembly() -> ListenFlowCoordinator.Assembly {
            return ListenFlowCoordinator.Assembly(appAssembly: appAssembly)
        }
    }
}
