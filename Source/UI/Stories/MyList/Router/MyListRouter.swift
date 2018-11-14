//
//  MainUIRouter.swift
//  Scout
//
//

import Foundation
import UIKit

class MyListRouter {
    var linkIsFound: ((ScoutArticle, Bool) -> Void)?
    var playNext: (() -> Void)?
    var pausePlayer: (() -> Void)?
    var stopPlayer: (() -> Void)?
    var resumePlayer: (() -> Void)?
    fileprivate var parentNavigationController: UINavigationController!
    fileprivate let assembly: MyListAssemblyProtocol

    required init(with assembly: MyListAssemblyProtocol) {
        self.assembly = assembly
    }
}

extension MyListRouter: MyListRoutingProtocol {
    func show(from viewController: UIViewController, animated: Bool, withUserID: String) {
        let listVC = assembly.assemblyMyListViewController()
        listVC.userID = withUserID
        listVC.playerDelegateFromMain = self
        self.showViewController(viewController: listVC, fromViewController: viewController, animated: animated)
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

extension MyListRouter: PlayListDelegate {
    func pause() {
        self.pausePlayer?()
    }

    func stop() {
        self.stopPlayer?()
    }

    func resume() {
        self.resumePlayer?()
    }

    func openPlayerFromMain(withModel: ScoutArticle, isFullArticle: Bool) {
        self.linkIsFound?(withModel, isFullArticle)
    }
}
