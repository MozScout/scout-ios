//
//  AppCoordinator.swift
//  Scout
//
//

import UIKit

class AppCoordinator {

    // MARK: - Private properties

    private var currentFlowCoordinator: FlowCoordinator?

    // MARK: - Public properties

    private let rootNavigation: RootNavigationViewController

    init(rootNavigation: RootNavigationViewController) {

        self.rootNavigation = rootNavigation
        rootNavigation.onRootWillAppear = { [weak self] in
            self?.runOnboardingFlow()
        }
    }

    // MARK: - Private methods

    private func runOnboardingFlow() {

    }
}
