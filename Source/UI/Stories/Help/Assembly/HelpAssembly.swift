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
        
        let vc = self.storyboard.instantiateViewController(withIdentifier: "HelpInformationViewController") as! HelpInformationViewController
        return vc
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension HelpAssembly {
    
    var storyboard: UIStoryboard { return UIStoryboard(name: "Help", bundle: nil) }
}
