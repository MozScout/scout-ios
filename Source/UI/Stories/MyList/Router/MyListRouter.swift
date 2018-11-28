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
    var isPlaying: (() -> Bool)?
    var isPlayerVisible: (() -> Bool)?
    var increasePlayerVolume: (() -> Void)?
    var decreasePlayerVolume: (() -> Void)?
    var setPlayerVolume: ((Float) -> (Float, Float)?)?
    var increasePlayerSpeed: (() -> Void)?
    var decreasePlayerSpeed: (() -> Void)?
    var skipPlayerTime: ((Int) -> Void)?
    var openVoiceInput: (() -> Void)?
    var hideVoiceInput: (() -> Void)?
    var addVoiceInputText: ((String, Bool) -> Void)?
    var setVoiceInputImage: ((UIImage) -> Void)?
    fileprivate var parentNavigationController: UINavigationController!
    fileprivate let assembly: MyListAssemblyProtocol

    private var listVC: MyListViewController?

    required init(with assembly: MyListAssemblyProtocol) {
        self.assembly = assembly
    }
}

extension MyListRouter: MyListRoutingProtocol {
    func show(from viewController: UIViewController, animated: Bool, withUserID: String) {
        self.listVC = assembly.assemblyMyListViewController()
        self.listVC!.userID = withUserID
        self.listVC!.playerDelegateFromMain = self
        self.listVC!.voiceInputDelegateFromMain = self
        self.showViewController(viewController: self.listVC!, fromViewController: viewController, animated: animated)
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

    func applicationDidBecomeActive() {
        if let listVC = self.listVC {
            listVC.applicationDidBecomeActive()
        }
    }

    func applicationWillResignActive() {
        if let listVC = self.listVC {
            listVC.applicationWillResignActive()
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

    func playing() -> Bool {
        if self.isPlaying != nil {
            return self.isPlaying!()
        }

        return false
    }

    func playerVisible() -> Bool {
        if self.isPlayerVisible != nil {
            return self.isPlayerVisible!()
        }

        return false
    }

    func increaseVolume() {
        self.increasePlayerVolume?()
    }

    func decreaseVolume() {
        self.decreasePlayerVolume?()
    }

    func setVolume(_ volume: Float) -> (Float, Float)? {
        return self.setPlayerVolume?(volume)
    }

    func increaseSpeed() {
        self.increasePlayerSpeed?()
    }

    func decreaseSpeed() {
        self.decreasePlayerSpeed?()
    }

    func skip(_ seconds: Int) {
        self.skipPlayerTime?(seconds)
    }

    func openPlayerFromMain(withModel: ScoutArticle, isFullArticle: Bool) {
        self.linkIsFound?(withModel, isFullArticle)
    }
}

extension MyListRouter: VoiceInputDelegate {
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
