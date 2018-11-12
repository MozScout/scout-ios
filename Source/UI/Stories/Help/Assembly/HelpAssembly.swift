//
//  MainAssembly.swift
//  Scout
//
//

import Foundation
import UIKit

class HelpAssembly: HelpAssemblyProtocol {
    fileprivate let applicationAssembly: ApplicationAssemblyProtocol

    required init(withAssembly assembly: ApplicationAssemblyProtocol) {
        self.applicationAssembly = assembly
    }

    func assemblyHelpInformationViewController() -> HelpInformationViewController {
        let helpInformationVC = self.storyboard.instantiateViewController(
            // swiftlint:disable:next force_cast
            withIdentifier: "HelpInformationViewController") as! HelpInformationViewController
        return helpInformationVC
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension HelpAssembly {
    var storyboard: UIStoryboard { return UIStoryboard(name: "Help", bundle: nil) }
}
