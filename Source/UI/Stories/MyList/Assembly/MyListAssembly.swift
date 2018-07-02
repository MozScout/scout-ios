//
//  MainAssembly.swift
//  Scout
//
//

import Foundation
import UIKit

class MyListAssembly: MyListAssemblyProtocol {
    
    fileprivate let applicationAssembly: ApplicationAssemblyProtocol
    
    required init(withAssembly assembly: ApplicationAssemblyProtocol) {
        
        self.applicationAssembly = assembly
    }
    
    func assemblyPlayMyListViewController() -> PlayMyListViewController {
     
        let vc = self.storyboard.instantiateViewController(withIdentifier: "PlayMyListViewController") as! PlayMyListViewController
        vc.scoutClient = self.applicationAssembly.assemblyNetworkClient() as! ScoutHTTPClient
        vc.keychainService = self.applicationAssembly.assemblyKeychainService() as! KeychainService
        
        return vc
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension MyListAssembly {
    
    var storyboard: UIStoryboard { return UIStoryboard(name: "MyList", bundle: nil) }
}
