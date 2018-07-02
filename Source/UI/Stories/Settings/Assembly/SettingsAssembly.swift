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
        
        let vc = self.storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        return vc
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension SettingsAssembly {
    
    var storyboard: UIStoryboard { return UIStoryboard(name: "Settings", bundle: nil) }
}
