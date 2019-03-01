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
                self?.showMyNotesScreen()
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
                self?.showSubscriptionsScreen()
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
//        showContent(<#T##content: UIViewController##UIViewController#>, for: startTab, animated: false)
    }

    private func showMyNotesScreen() { }

    private func showListenScreen() { }

    private func showSubscriptionsScreen() { }

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
    }
}
