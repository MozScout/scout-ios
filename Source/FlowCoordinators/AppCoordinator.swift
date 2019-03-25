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

    private let intentPerformer: IntentPerformer

    private lazy var launchInstructor: LaunchInstructor = {
        return appAssembly.assemblyAppCoordinatorStartInstructor()
    }()

    // MARK: - Init

    init(rootNavigation: RootNavigationViewController) {
        self.appAssembly = AppAssembly()
        self.rootNavigation = rootNavigation
        self.intentPerformer = appAssembly.assemblyIntentPerformer()
        
        rootNavigation.onRootWillAppear = { [weak self] in
            self?.startFlow()
        }

        if UserDefaults.standard.value(forKey: "first_launch") == nil {
            appAssembly.assemblyUserDataManager().userId = nil
            appAssembly.assemblyAccessTokenManager().setBearerToken(nil)

            UserDefaults.standard.setValue(1, forKey: "first_launch")
        }

        

    }

    // MARK: - Private methods

    private func startFlow() {
        switch launchInstructor.instruct() {
        case .onboarding:
            runOnboardingFlow()
        case .signedIn:
            runSignedInFlow()
        }
    }

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

extension AppCoordinator {
    
    class LaunchInstructor {

        private let userDataProvider: UserDataProvider
        private let authTokenProvider: RequestAuthorizationTokenProvider

        init(
            userDataProvider: UserDataProvider,
            authTokenProvider: RequestAuthorizationTokenProvider
            ) {

            self.userDataProvider = userDataProvider
            self.authTokenProvider = authTokenProvider
        }

        func instruct() -> LaunchFlow {
            if userDataProvider.userId == nil {
                return .onboarding
            } else if authTokenProvider.bearerToken == nil {
                // FIXME: - Return login here when available
                return .onboarding
            } else {
                return .signedIn
            }
        }
    }
}

extension AppCoordinator.LaunchInstructor {
    enum LaunchFlow {
        case onboarding
        case signedIn
    }
}
