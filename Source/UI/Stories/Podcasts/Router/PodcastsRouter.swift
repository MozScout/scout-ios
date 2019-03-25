//
//  PodcastsRouter.swift
//  Scout
//
//
import UIKit

class PodcastsRouter {
    var linkIsFound: ((ScoutArticle?) -> Void)?
    var addPodcasts: (() -> Void)?
    var openVoiceInput: (() -> Void)?
    var hideVoiceInput: (() -> Void)?
    var addVoiceInputText: ((String, Bool) -> Void)?
    var setVoiceInputImage: ((UIImage) -> Void)?
    fileprivate var parentNavigationController: UINavigationController!
    fileprivate let assembly: PodcastsAssemblyProtocol

    required init(with assembly: PodcastsAssemblyProtocol) {
        self.assembly = assembly
    }
}

extension PodcastsRouter: PodcastsRoutingProtocol {
    func show(from viewController: UIViewController, animated: Bool, withUserID: String) {
        let podcastsVC = assembly.assemblyPodcastsViewController()
        podcastsVC.podcastsDelegate = self
        podcastsVC.voiceInputDelegateFromMain = self
        self.showViewController(viewController: podcastsVC, fromViewController: viewController, animated: animated)
    }

    func showPodcastDetails(from viewController: UIViewController,
                            animated: Bool,
                            withUserID: String,
                            article: ScoutArticle?) {
        let podcastsVC = assembly.assemblyPodcastDetailsViewController()
        podcastsVC.model = article

        self.showViewController(viewController: podcastsVC, fromViewController: viewController, animated: animated)
    }

    func showAddPodcasts(from viewController: UIViewController, animated: Bool, withUserID: String) {
        let podcastsVC = assembly.assemblyAddPodcastsViewController()

        self.showViewController(viewController: podcastsVC, fromViewController: viewController, animated: animated)
    }

    // MARK: -
    // MARK: Private
    private func showViewController(viewController: UIViewController,
                                    fromViewController: UIViewController,
                                    animated: Bool) {
        if let navigationVC = fromViewController as? UINavigationController {
            if navigationVC.viewControllers.count == 0 {
                navigationVC.viewControllers = [viewController]
            } else {
                navigationVC.pushViewController(viewController, animated: animated)
            }
        } else if let navigationVC = fromViewController.navigationController {
            if navigationVC.viewControllers.count == 0 {
                navigationVC.viewControllers = [viewController]
            } else {
                navigationVC.pushViewController(viewController, animated: animated)
            }
        } else {
            print("Unsupported navigation")
        }
    }
}

extension PodcastsRouter: PodcastsDelegate {
    func openPodcastDetails(_ article: ScoutArticle?) {
        self.linkIsFound?(article)
    }
    func openAddPodcasts() {
        self.addPodcasts?()
    }
}

extension PodcastsRouter: VoiceInputDelegate {
    func openVoiceInputFromMain() {
        self.openVoiceInput?()
    }

    func hideVoiceInputFromMain() {
        self.hideVoiceInput?()
    }

    func addVoiceInputTextFromMain(_ text: String, fromUser: Bool) {
        self.addVoiceInputText?(text, fromUser)
    }

    func setVoiceInputImageFromMain(_ image: UIImage) {
        self.setVoiceInputImage?(image)
    }
}
