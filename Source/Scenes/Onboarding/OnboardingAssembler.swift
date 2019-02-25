import UIKit

// MARK: - Protocol
protocol OnboardingAssembler {

    // MARK: Typealiases

    typealias Output = Onboarding.Output

    // MARK: Requirements

    func assembly(with output: Output) -> Onboarding.ViewController
}

extension Onboarding {
    
    typealias Assembler = OnboardingAssembler

    // MARK: - Declaration
    class AssemblerImp {
        typealias Interactor = Onboarding.Interactor
        typealias InteractorImp = Onboarding.InteractorImp
        typealias InteractorDispatcher = Onboarding.InteractorDispatcher
        typealias PresenterImp = Onboarding.PresenterImp
        typealias PresenterDispatcher = Onboarding.PresenterDispatcher
        typealias ViewControllerImp = Onboarding.ViewControllerImp
    }
}

//MARK: - Assembler
extension Onboarding.AssemblerImp: Onboarding.Assembler {

    func assembly(with output: Output) -> Onboarding.ViewController {
        let viewController = ViewControllerImp(output: output)
        let presenterDispatcher = PresenterDispatcher(queue: DispatchQueue.main, recipient: Weak(viewController))
        let presenter = PresenterImp(presenterDispatcher: presenterDispatcher)
        let interactor = InteractorImp(presenter: presenter)
        let interactorDispatcher = InteractorDispatcher(
            queue: DispatchQueue(
                label: "\(NSStringFromClass(InteractorDispatcher.self))\(Interactor.self)".queueLabel,
                qos: .userInteractive
            ),
            recipient: interactor
        )

        viewController.inject(interactorDispatcher: interactorDispatcher)

        return viewController
    }
}
