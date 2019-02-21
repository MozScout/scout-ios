//
//  BaseFlowCoordinator.swift
//  Scout
//
//

import Foundation

class BaseFlowCoordinator: FlowCoordinator {

    var currentFlowCoordinator: FlowCoordinator?

    // MARK: - Public properties

    let rootNavigation: RootNavigationProtocol

    init(rootNavigation: RootNavigationProtocol) {

        self.rootNavigation = rootNavigation
    }

    // MARK: - FlowCoordinator

    func applicationDidBecomeActive() {
        currentFlowCoordinator?.applicationDidBecomeActive()
    }

    func applicationWillResignActive() {
        currentFlowCoordinator?.applicationWillResignActive()
    }

    func applicationDidEnterBackground() {
        currentFlowCoordinator?.applicationDidEnterBackground()
    }

    func applicationWillEnterForeground() {
        currentFlowCoordinator?.applicationWillEnterForeground()
    }
}
