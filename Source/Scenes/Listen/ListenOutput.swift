import Foundation

extension Listen {

    // MARK: - Declaration
    
    struct Output {

        let onShowPlayer: () -> Void
        let onHandsFree: () -> Void
        let onBack: () -> Void
        let onSearch: () -> Void
    }
}
