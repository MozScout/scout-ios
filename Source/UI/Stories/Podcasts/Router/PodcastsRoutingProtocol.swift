//
//  PodcastsRoutingProtocol.swift
//  Scout
//
//
import UIKit

protocol PodcastsRoutingProtocol {
    var linkIsFound: (() -> Void)? { get set }
    var addPodcasts: (() -> Void)? { get set }
    func show(from viewController: UIViewController, animated: Bool, withUserID: String)
    func showPodcastDetails(from viewController: UIViewController, animated: Bool, withUserID: String)
    func showAddPodcasts(from viewController: UIViewController, animated: Bool, withUserID: String)
}
