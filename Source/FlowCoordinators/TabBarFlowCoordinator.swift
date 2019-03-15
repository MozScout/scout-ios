//
//  TabBarFlowCoordinator.swift
//  Scout
//
//

import UIKit

class TabBarFlowCoordinator: BaseFlowCoordinator {

    enum Tab {
        case myNotes
        case listen
        case subscriptions
    }

    private let assembly: Assembly
    private let tabBarController: TabBarContainerController = TabBarContainerController()

    typealias TabItem = (tab: Tab, item: TabBarContainerController.Item)
    private var items: [TabItem] = []
    private var currentTab: Tab? = nil

    private let startTab: Tab = .listen

    private lazy var myNotesFlow: MyNotesFlowCoordinator = createMyNotesFlow()
    private lazy var subscriptionsFlow: SubscriptionsFlowCoordinator = createSubscriptionsFlow()
    private lazy var listenFlow: ListenFlowCoordinator = createListenFlow()
    private lazy var playerFlow: PlayerFlowCoordinator = createPlayerFlow()

    init(
        rootNavigation: RootNavigationProtocol,
        assembly: Assembly
        ) {

        self.assembly = assembly

        super.init(rootNavigation: rootNavigation)

        let myNotesItem = TabBarContainerController.Item(
            title: "My Notes",
            icon: UIImage.fxNotesTabIcon,
            onSelect: { [weak self] in
                self?.showMyNotesFlow(animated: true)
        })

        let listenItem = TabBarContainerController.Item(
            title: "Listen",
            icon: UIImage.fxListenTabIcon,
            onSelect: { [weak self] in
                self?.showListenFlow(animated: true)
        })

        let subscriptionsItem = TabBarContainerController.Item(
            title: "Subscriptions",
            icon: UIImage.fxSubscriptionsTabIcon,
            onSelect: { [weak self] in
                self?.showSubscriptionsFlow(animated: true)
        })

        items = [
            (tab: .myNotes, item: myNotesItem),
            (tab: .listen, item: listenItem),
            (tab: .subscriptions, item: subscriptionsItem)
        ]
    }

    func run() {
        rootNavigation.setRootContent(
            tabBarController,
            transition: .fade,
            animated: true
        )

        let index = getIndex(for: startTab)
        let items = self.items.map { (_, item) -> TabBarContainerController.Item in
            return item
        }
        tabBarController.setItems(items, selectedIndex: index)
        showListenFlow(animated: true)
    }

    private func showMyNotesFlow(animated: Bool) {
        myNotesFlow.showContent(animated: animated)
        currentFlowCoordinator = myNotesFlow
    }

    private func showListenFlow(animated: Bool) {
        listenFlow.showContent(animated: animated)
        currentFlowCoordinator = listenFlow
    }

    private func showSubscriptionsFlow(animated: Bool) {
        subscriptionsFlow.showContent(animated: animated)
        currentFlowCoordinator = subscriptionsFlow
    }

    private func showPlayer(animated: Bool) {
        playerFlow.showContent(animated: animated)
        currentFlowCoordinator = playerFlow
    }

    private func showContent(
        _ content: UIViewController,
        for targetTab: Tab,
        animated: Bool
        ) {

        guard targetTab != currentTab else { return }

        let index = getIndex(for: targetTab)
        currentTab = targetTab
        tabBarController.transitionToContent(content, at: index, animated: animated)
    }

    private func getIndex(for tab: Tab) -> Int {
        return items.firstIndex { $0.tab == tab } ?? 0
    }

    // MARK: - Lazy loadings

    private func createMyNotesFlow() -> MyNotesFlowCoordinator {
        let assembly = self.assembly.assemblyMyNotesFlowCoordinatorAssembly()

        let flowCoordinator = MyNotesFlowCoordinator(
            rootNavigation: rootNavigation,
            assembly: assembly,
            show: { [weak self] (controller, animated) in
                self?.showContent(controller, for: .myNotes, animated: animated)
        })

        return flowCoordinator
    }

    private func createSubscriptionsFlow() -> SubscriptionsFlowCoordinator {
        let assembly = self.assembly.assemblySubscriptionsFlowCoordinatorAssembly()

        let flowCoordinator = SubscriptionsFlowCoordinator(
            rootNavigation: rootNavigation,
            assembly: assembly,
            show: { [weak self] (controller, animated) in
                self?.showContent(controller, for: .subscriptions, animated: animated)
        })

        return flowCoordinator
    }

    private func createListenFlow() -> ListenFlowCoordinator {
        let assembly = self.assembly.assemblyListenFlowCoordinatorAssembly()

        let flowCoordinator = ListenFlowCoordinator(
            rootNavigation: rootNavigation,
            assembly: assembly,
            show: { [weak self] (controller, animated) in
                self?.showContent(controller, for: .listen, animated: animated)
            },
            onShowPlayer: { [weak self] in
                self?.showPlayer(animated: true)
        })

        return flowCoordinator
    }

    private func createPlayerFlow() -> PlayerFlowCoordinator {
        let assemby = self.assembly.assemblyPlayerFlowCoordinatorAssembly()

        let flowCoordinator = PlayerFlowCoordinator(
            rootNavigation: rootNavigation,
            assembly: assemby,
            show: { [weak self] (controller, animated) in
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .coverVertical
                self?.tabBarController.present(controller, animated: animated, completion: nil)
            },
            hide: { (controller, animated) in
                controller.dismiss(animated: animated, completion: nil)
        })

        return flowCoordinator
    }
}

extension TabBarFlowCoordinator {

    class Assembly {

        private let appAssembly: AppAssembly

        init(appAssembly: AppAssembly) {

            self.appAssembly = appAssembly
        }

        public func assemblyMyNotesFlowCoordinatorAssembly() -> MyNotesFlowCoordinator.Assembly {
            return MyNotesFlowCoordinator.Assembly()
        }

        public func assemblySubscriptionsFlowCoordinatorAssembly() -> SubscriptionsFlowCoordinator.Assembly {
            return SubscriptionsFlowCoordinator.Assembly(appAssembly: appAssembly)
        }

        func assemblyListenFlowCoordinatorAssembly() -> ListenFlowCoordinator.Assembly {
            return ListenFlowCoordinator.Assembly(appAssembly: appAssembly)
        }

        func assemblyPlayerFlowCoordinatorAssembly() -> PlayerFlowCoordinator.Assembly {
            return PlayerFlowCoordinator.Assembly(appAssembly: appAssembly)
        }
    }
}
