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

    func assemblyMyListViewController() -> MyListViewController {
        let myListVC = self.storyboard.instantiateViewController(
            // swiftlint:disable:next force_cast
            withIdentifier: "MyListViewController") as! MyListViewController
        myListVC.scoutClient = self.applicationAssembly.assemblyNetworkClient() as? ScoutHTTPClient
        myListVC.keychainService = self.applicationAssembly.assemblyKeychainService() as? KeychainService
        myListVC.speechService = self.applicationAssembly.assemblySpeechService() as? SpeechService
        myListVC.beginWakeWordDetector()

        return myListVC
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension MyListAssembly {
    var storyboard: UIStoryboard { return UIStoryboard(name: "MyList", bundle: nil) }
}
