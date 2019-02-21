//
//  FlowCoordinator.swift
//  Scout
//
//

import Foundation

protocol FlowCoordinator {

    var currentFlowCoordinator: FlowCoordinator? { get set }

    // MARK: - App life cycle

    func applicationDidEnterBackground()
    func applicationWillEnterForeground()
    func applicationDidBecomeActive()
    func applicationWillResignActive()
}
