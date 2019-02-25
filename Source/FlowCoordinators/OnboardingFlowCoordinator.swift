//
//  OnboardingFlowCoordinator.swift
//  Scout
//
//

import UIKit

class OnboardingFlowCoordinator: BaseFlowCoordinator {

    typealias OnSignedUpCallback = () -> Void

    private let assembly: Assembly
    private let onSignedUp: OnSignedUpCallback

    init(
        rootNavigation: RootNavigationProtocol,
        assembly: Assembly,
        onSignedUp: @escaping OnSignedUpCallback
        ) {

        self.assembly = assembly
        self.onSignedUp = onSignedUp

        super.init(rootNavigation: rootNavigation)
    }

    func run() {
        onSignedUp()
    }
}

extension OnboardingFlowCoordinator {
    
    class Assembly {

        private let appAssembly: AppAssembly

        init(appAssembly: AppAssembly) {

            self.appAssembly = appAssembly
        }
    }
}
