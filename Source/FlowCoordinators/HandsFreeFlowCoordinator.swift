//
//  HandsFreeFlowCoordinator.swift
//  Scout
//
//

import UIKit

class HandsFreeFlowCoordinator: BaseFlowCoordinator {

    typealias ShowClosure = (_ content: UIViewController, _ animated: Bool) -> Void
    typealias HideClosure = (_ content: UIViewController, _ animated: Bool) -> Void

    private let assembly: Assembly
    private let show: ShowClosure
    private let hide: HideClosure

    private lazy var partScreenContainer: PartScreenContainerViewController = createPartScreenContainer()

    init(
        rootNavigation: RootNavigationProtocol,
        assembly: Assembly,
        show: @escaping ShowClosure,
        hide: @escaping HideClosure
        ) {

        self.assembly = assembly
        self.show = show
        self.hide = hide

        super.init(rootNavigation: rootNavigation)
    }

    func showHandsFreeMode(animated: Bool) {
        let output = HandsFreeMode.Output(onCancelAction: { [weak self] in
            self?.onHide()
        })

        let handsFreeModeScene = assembly.assemblyHandsFreeMode(output: output)
        partScreenContainer.setContent(handsFreeModeScene)

        show(partScreenContainer, animated)
    }

    func showRecognition(animated: Bool) {
        let output = Recognition.Output(onCancelAction: { [weak self] in
            self?.onHide()
        })

        let recognitionScene = assembly.assemblyRecognition(output: output)
        partScreenContainer.setContent(recognitionScene)

        show(partScreenContainer, animated)
    }

    private func createPartScreenContainer() -> PartScreenContainerViewController {
        let container = PartScreenContainerViewController()
        container.onDismiss = { [weak self] in
            self?.onHide()
        }

        return container
    }

    private func onHide() {
        hide(partScreenContainer, true)
    }
}

extension HandsFreeFlowCoordinator {

    class Assembly {

        private let appAssembly: AppAssembly

        init(appAssembly: AppAssembly) {

            self.appAssembly = appAssembly
        }

        func assemblyHandsFreeMode(output: HandsFreeMode.Output) -> HandsFreeMode.ViewControllerImp {
            let assembler = HandsFreeMode.AssemblerImp(
//                appAssembly: appAssembly
            )
            return assembler.assembly(with: output)
        }

        func assemblyRecognition(output: Recognition.Output) -> Recognition.ViewControllerImp {
            let assembler = Recognition.AssemblerImp(
//                appAssembly: appAssembly
            )
            return assembler.assembly(with: output)
        }
    }
}
