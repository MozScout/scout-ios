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
        let podcastsVC = self.storyboard.instantiateViewController(
            // swiftlint:disable:next force_cast
            withIdentifier: "PodcastsViewController") as! PodcastsViewController
        podcastsVC.scoutClient = self.applicationAssembly.assemblyNetworkClient() as? ScoutHTTPClient
        podcastsVC.keychainService = self.applicationAssembly.assemblyKeychainService() as? KeychainService
        return podcastsVC
    }

    func assemblyPodcastDetailsViewController() -> PodcastDetailsViewController {
        let podcastsVC = self.podacstDetailsStoryboard.instantiateViewController(
            // swiftlint:disable:next force_cast
            withIdentifier: "PodcastDetailsViewController") as! PodcastDetailsViewController
        //podcastsVC.scoutClient = self.applicationAssembly.assemblyNetworkClient() as? ScoutHTTPClient
        //podcastsVC.keychainService = self.applicationAssembly.assemblyKeychainService() as? KeychainService
        return podcastsVC
    }

    func assemblyAddPodcastsViewController() -> AddPodcastsViewController {
        let addPodcastsVC = self.addPodacstsStoryboard.instantiateViewController(
            // swiftlint:disable:next force_cast
            withIdentifier: "AddPodcastsViewController") as! AddPodcastsViewController
        //podcastsVC.scoutClient = self.applicationAssembly.assemblyNetworkClient() as? ScoutHTTPClient
        //podcastsVC.keychainService = self.applicationAssembly.assemblyKeychainService() as? KeychainService
        return addPodcastsVC
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension PodcastsAssembly {
    var storyboard: UIStoryboard { return UIStoryboard(name: "Podcasts", bundle: nil) }
    var podacstDetailsStoryboard: UIStoryboard { return UIStoryboard(name: "PodcastDetails", bundle: nil) }
    var addPodacstsStoryboard: UIStoryboard { return UIStoryboard(name: "AddPodcasts", bundle: nil) }
}
