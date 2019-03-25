//
//  PodcastsRoutingProtocol.swift
//  Scout
//
//
import UIKit

protocol PodcastsRoutingProtocol {
    var linkIsFound: ((ScoutArticle?) -> Void)? { get set }
    var addPodcasts: (() -> Void)? { get set }
    var openVoiceInput: (() -> Void)? { get set }
    var hideVoiceInput: (() -> Void)? { get set }
    var addVoiceInputText: ((String, Bool) -> Void)? { get set }
    var setVoiceInputImage: ((UIImage) -> Void)? { get set }
    func show(from viewController: UIViewController, animated: Bool, withUserID: String)
    func showPodcastDetails(from viewController: UIViewController,
                            animated: Bool,
                            withUserID: String,
                            article: ScoutArticle?)
    func showAddPodcasts(from viewController: UIViewController, animated: Bool, withUserID: String)
}
