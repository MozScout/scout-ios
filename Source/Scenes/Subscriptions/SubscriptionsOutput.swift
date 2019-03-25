import Foundation

extension Subscriptions {

    // MARK: - Declaration
    
    struct Output {

        let onAddAction: () -> Void
        let onHandsFree: () -> Void
        let onSearch: () -> Void
    }
}
