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
        let output = Onboarding.Output(onStartAction: {})
        rootNavigation.setRootContent(assembly.assemblyOnboarding(output: output), transition: .fade, animated: false)
    }
}

extension OnboardingFlowCoordinator {
    
    class Assembly {

        private let appAssembly: AppAssembly

        init(appAssembly: AppAssembly) {

            self.appAssembly = appAssembly
        }

        func assemblyOnboarding(output: Onboarding.Output) -> Onboarding.ViewController {
            let assembler = Onboarding.AssemblerImp()
            return assembler.assembly(with: output)
        }
    }
}
