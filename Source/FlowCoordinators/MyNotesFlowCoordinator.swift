//
//  MyNotesFlowCoordinator.swift
//  Scout
//
//

import UIKit

class MyNotesFlowCoordinator: BaseFlowCoordinator {

    typealias ShowClosure = (_ content: UIViewController, _ animated: Bool) -> Void

    private let assembly: Assembly

    private lazy var navigationController: UINavigationController = {
        let navigation = UINavigationController()
        navigation.setNavigationBarHidden(true, animated: false)

        let navigationBarController = createController()

        navigation.setViewControllers([navigationBarController], animated: false)

        return navigation
    }()

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

    private func createController() -> UIViewController {
        let navigationBarController = NavigationBarContainerController()
        _ = navigationBarController.view
        let navigationBar = DefaultNavigationBar.loadFromNib()
        navigationBarController.setNavigationBarContent(navigationBar)
        return navigationBarController
    }
}

extension MyNotesFlowCoordinator {

    class Assembly { }
}
