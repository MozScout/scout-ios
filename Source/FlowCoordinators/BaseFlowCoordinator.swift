//
//  BaseFlowCoordinator.swift
//  Scout
//
//

import Foundation

class BaseFlowCoordinator: FlowCoordinator {

    var currentFlowController: FlowCoordinator?

    // MARK: - Public properties

    let rootNavigation: RootNavigationProtocol

    init(rootNavigation: RootNavigationProtocol) {

        self.rootNavigation = rootNavigation
    }

    // MARK: - FlowCoordinator

    func applicationDidBecomeActive() {
        currentFlowController?.applicationDidBecomeActive()
    }

    func applicationWillResignActive() {
        currentFlowController?.applicationWillResignActive()
    }

    func applicationDidEnterBackground() {
        currentFlowController?.applicationDidEnterBackground()
    }

    func applicationWillEnterForeground() {
        currentFlowController?.applicationWillEnterForeground()
    }
}
