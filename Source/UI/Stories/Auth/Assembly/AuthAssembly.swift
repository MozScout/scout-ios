//
//  MainAssembly.swift
//  Scout
//
//

import Foundation
import UIKit

class AuthAssembly: AuthAssemblyProtocol {
    
    fileprivate let applicationAssembly: ApplicationAssemblyProtocol
    
    required init(withAssembly assembly: ApplicationAssemblyProtocol) {
        
        self.applicationAssembly = assembly
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension AuthAssembly {
    
    var storyboard: UIStoryboard { return UIStoryboard(name: "Auth", bundle: nil) }
}
