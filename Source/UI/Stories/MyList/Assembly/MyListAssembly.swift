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

        let playMyListVC = self.storyboard.instantiateViewController(
            // swiftlint:disable:next force_cast
            withIdentifier: "PlayMyListViewController") as! PlayMyListViewController
        playMyListVC.scoutClient = self.applicationAssembly.assemblyNetworkClient() as? ScoutHTTPClient
        playMyListVC.keychainService = self.applicationAssembly.assemblyKeychainService() as? KeychainService

        return playMyListVC
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension MyListAssembly {

    var storyboard: UIStoryboard { return UIStoryboard(name: "MyList", bundle: nil) }
}
