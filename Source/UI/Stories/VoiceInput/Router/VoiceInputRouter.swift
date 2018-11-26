//
//  VoiceInputRouter.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import Foundation
import UIKit

class VoiceInputRouter {
    var onCloseButtonTap: (() -> Void)?
    fileprivate var parentNavigationController: UINavigationController!
    fileprivate let assembly: VoiceInputAssemblyProtocol
    var voiceInputVC: VoiceInputViewController?

    required init(with assembly: VoiceInputAssemblyProtocol) {
        self.assembly = assembly
    }
}

extension VoiceInputRouter: VoiceInputRoutingProtocol {
    func show(from viewController: UIViewController, animated: Bool) {
        self.voiceInputVC = assembly.assemblyVoiceInputViewController()
        self.showViewController(viewController: self.voiceInputVC!,
                                fromViewController: viewController,
                                animated: animated)
    }

    func addText(_ text: String, fromUser: Bool) {
        if self.isVisible() {
            self.voiceInputVC!.addText(text, fromUser: fromUser)
        }
    }

    func setImage(_ image: UIImage) {
        if self.isVisible() {
            self.voiceInputVC!.setImage(image)
        }
    }

    private func isVisible() -> Bool {
        return self.voiceInputVC != nil && self.voiceInputVC!.viewIfLoaded?.window != nil
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
