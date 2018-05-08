//
//  MainAssembly.swift
//  Scout
//
//

import Foundation
import UIKit

class MainAssembly: MainAssemblyProtocol {
    
    fileprivate let applicationAssembly: ApplicationAssemblyProtocol
    
    required init(withAssembly assembly: ApplicationAssemblyProtocol) {
        
        self.applicationAssembly = assembly
    }

    func assemblyMainViewController() -> ViewController {
        
        let vc = self.storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        return vc
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension MainAssembly {
    
    var storyboard: UIStoryboard { return UIStoryboard(name: "Main", bundle: nil) }
}
