import Foundation

extension Onboarding {

    // MARK: - Declaration
    struct Output {

        typealias OnDidRegister = (_ userId: String, _ token: String) -> Void

        let onDidRegister: OnDidRegister
        let onShowLoading: () -> Void
        let onHideLoading: () -> Void
    }
}
