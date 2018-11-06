//
//  PlayerAssembly.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import Foundation
import UIKit

class PlayerAssembly: PlayerAssemblyProtocol {

    let applicationAssembly: ApplicationAssemblyProtocol

    required init(withAssembly assembly: ApplicationAssemblyProtocol) {

        self.applicationAssembly = assembly
    }

    func assemblyPlayerViewController() -> PlayerViewController {

        let playerVC = self.storyboard.instantiateViewController(
            withIdentifier: "PlayerViewController") as! PlayerViewController
        playerVC.scoutClient = self.applicationAssembly.assemblyNetworkClient() as! ScoutHTTPClient
        playerVC.keychainService = self.applicationAssembly.assemblyKeychainService() as! KeychainService

        return playerVC
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension PlayerAssembly {

    var storyboard: UIStoryboard { return UIStoryboard(name: "Player", bundle: nil) }
}
