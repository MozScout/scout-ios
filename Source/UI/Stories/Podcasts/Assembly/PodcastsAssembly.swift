//
//  PodcastsAssembly.swift
//  Scout
//
//

import Foundation
import UIKit

class PodcastsAssembly: PodcastsAssemblyProtocol {

    fileprivate let applicationAssembly: ApplicationAssemblyProtocol

    required init(withAssembly assembly: ApplicationAssemblyProtocol) {

        self.applicationAssembly = assembly
    }

    func assemblyPodcastsViewController() -> PodcastsViewController {
        let podcastsVC = self.storyboard.instantiateViewController(withIdentifier: "PodcastsViewController") as! PodcastsViewController
        podcastsVC.scoutClient = self.applicationAssembly.assemblyNetworkClient() as? ScoutHTTPClient
        podcastsVC.keychainService = self.applicationAssembly.assemblyKeychainService() as? KeychainService
        return podcastsVC
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension PodcastsAssembly {

    var storyboard: UIStoryboard { return UIStoryboard(name: "Podcasts", bundle: nil) }
}
