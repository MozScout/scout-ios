import Foundation

extension Onboarding {

    // MARK: - Declaration
    struct Output {

        typealias OnDidRegister = () -> Void

        let onDidRegister: OnDidRegister
        let onShowLoading: () -> Void
        let onHideLoading: () -> Void
    }
}
