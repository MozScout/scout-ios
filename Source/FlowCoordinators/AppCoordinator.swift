//
//  AppCoordinator.swift
//  Scout
//
//

import UIKit

class AppCoordinator {

    // MARK: - Private properties

    private var currentFlowCoordinator: FlowCoordinator?

    private let appAssembly: AppAssembly
    private let rootNavigation: RootNavigationViewController

    // MARK: - Init

    init(rootNavigation: RootNavigationViewController) {

        self.appAssembly = AppAssembly()
        self.rootNavigation = rootNavigation
        
        rootNavigation.onRootWillAppear = { [weak self] in
            self?.runOnboardingFlow()
        }
    }

    // MARK: - Private methods

    private func runOnboardingFlow() {
        let assembly = appAssembly.assemblyOnboardingFlowCoordinatorAssembly()
        let flow = OnboardingFlowCoordinator(
            rootNavigation: rootNavigation,
            assembly: assembly,
            onSignedUp: { [weak self] in
                self?.runSignedInFlow()
        })
        currentFlowCoordinator = flow
        flow.run()
    }

    private func runSignedInFlow() {
        let assembly = appAssembly.assemblyTabBarFlowCoordinatorAssembly()
        let flow = TabBarFlowCoordinator(
            rootNavigation: rootNavigation,
            assembly: assembly
        )
        currentFlowCoordinator = flow
        flow.run()
    }
}
