//
//  PlayerAssemly.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import Foundation
import UIKit

class PlayerAssemly: PlayerAssemlyProtocol {
    
    let applicationAssembly: ApplicationAssemblyProtocol
    
    required init(withAssembly assembly: ApplicationAssemblyProtocol) {
        
        self.applicationAssembly = assembly
    }
    
    func assemblyPlayerViewController() -> PlayerViewController {
        
        let playerVC = self.storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        playerVC.scoutClient = self.applicationAssembly.assemblyNetworkClient() as? ScoutHTTPClient
        
        return playerVC
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension PlayerAssemly {
    
    var storyboard: UIStoryboard { return UIStoryboard(name: "Player", bundle: nil) }
}
