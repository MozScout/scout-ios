//
//  MainAssembly.swift
//  Scout
//
//

import Foundation
import UIKit

class SettingsAssembly: SettingsAssemblyProtocol {
    fileprivate let applicationAssembly: ApplicationAssemblyProtocol

    required init(withAssembly assembly: ApplicationAssemblyProtocol) {
        self.applicationAssembly = assembly
    }

    func assemblySettingsViewController() -> SettingsViewController {
        let settingsVC = self.storyboard.instantiateViewController(
            // swiftlint:disable:next force_cast
            withIdentifier: "SettingsViewController") as! SettingsViewController
        settingsVC.keychainService = self.applicationAssembly.assemblyKeychainService() as? KeychainService

        return settingsVC
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension SettingsAssembly {
    var storyboard: UIStoryboard { return UIStoryboard(name: "Settings", bundle: nil) }
}
