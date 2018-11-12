//
//  PodcastsAssemblyProtocol.swift
//  Scout
//
//
import UIKit

protocol PodcastsAssemblyProtocol {
    func assemblyPodcastsViewController() -> PodcastsViewController
    func assemblyPodcastDetailsViewController() -> PodcastDetailsViewController
    func assemblyAddPodcastsViewController() -> AddPodcastsViewController
}
