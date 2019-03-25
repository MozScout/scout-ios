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
    private let loadingOverlayViewController: LoadingOverlayViewController = LoadingOverlayViewController()

    init(
        rootNavigation: RootNavigationProtocol,
        assembly: Assembly,
        onSignedUp: @escaping OnSignedUpCallback
        ) {

        self.assembly = assembly
        self.onSignedUp = onSignedUp

        loadingOverlayViewController.modalPresentationStyle = .overCurrentContext

        super.init(rootNavigation: rootNavigation)
    }

    func run() {
        let output = Onboarding.Output(
            onDidRegister: { [weak self] in
                self?.onSignedUp()
            },
            onShowLoading: { [weak self] in
                self?.showLoading()
            },
            onHideLoading: { [weak self] in
                self?.hideLoading()
        })
        let viewController = assembly.assemblyOnboarding(output: output)
        rootNavigation.setRootContent(viewController, transition: .fade, animated: false)
    }

    func showLoading() {
        loadingOverlayViewController.startLoading()
        rootNavigation.presentController(loadingOverlayViewController, animated: false, completion: nil)
    }

    func hideLoading() {
        loadingOverlayViewController.dismiss(animated: false, completion: nil)
        loadingOverlayViewController.stopLoading()
    }
}

extension OnboardingFlowCoordinator {
    
    class Assembly {

        private let appAssembly: AppAssembly

        init(appAssembly: AppAssembly) {

            self.appAssembly = appAssembly
        }

        func assemblyOnboarding(output: Onboarding.Output) -> Onboarding.ViewController {
            let assembler = Onboarding.AssemblerImp(appAssembly: appAssembly)
            return assembler.assembly(with: output)
        }
    }
}
