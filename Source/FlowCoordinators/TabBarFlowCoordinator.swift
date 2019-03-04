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

    private lazy var myNotesFlow: MyNotesFlowCoordinator = {
        let assembly = self.assembly.assemblyMyNotesFlowCoordinatorAssembly()

        let flowCoordinator = MyNotesFlowCoordinator(
            rootNavigation: rootNavigation,
            assembly: assembly,
            show: { [weak self] (controller, animated) in
                self?.showContent(controller, for: .myNotes, animated: animated)
        })

        return flowCoordinator
    }()

    private lazy var subscriptionsFlow: SubscriptionsFlowCoordinator = {
        let assembly = self.assembly.assemblySubscriptionsFlowCoordinatorAssembly()

        let flowCoordinator = SubscriptionsFlowCoordinator(
            rootNavigation: rootNavigation,
            assembly: assembly,
            show: { [weak self] (controller, animated) in
                self?.showContent(controller, for: .subscriptions, animated: animated)
        })

        return flowCoordinator
    }()

    init(
        rootNavigation: RootNavigationProtocol,
        assembly: Assembly
        ) {

        self.assembly = assembly

        super.init(rootNavigation: rootNavigation)

        let myNotesItem = TabBarContainerController.Item(
            title: "My Notes",
            icon: #imageLiteral(resourceName: "Notes"),
            onSelect: { [weak self] in
                self?.showMyNotesFlow(animated: true)
        })

        let listenItem = TabBarContainerController.Item(
            title: "Listen",
            icon: #imageLiteral(resourceName: "Headphones"),
            onSelect: { [weak self] in
                self?.showListenScreen()
        })

        let subscriptionsItem = TabBarContainerController.Item(
            title: "Subscriptions",
            icon: #imageLiteral(resourceName: "Podcasts"),
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
        showListenScreen()
    }

    private func showMyNotesFlow(animated: Bool) {
        myNotesFlow.showContent(animated: animated)
        currentFlowCoordinator = myNotesFlow
    }

    private func showListenScreen() { }

    private func showSubscriptionsFlow(animated: Bool) {
        subscriptionsFlow.showContent(animated: animated)
        currentFlowCoordinator = subscriptionsFlow
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
            return SubscriptionsFlowCoordinator.Assembly()
        }
    }
}
