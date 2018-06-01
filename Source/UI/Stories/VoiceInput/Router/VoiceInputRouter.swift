//
//  VoiceInputRouter.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import Foundation
import UIKit

class VoiceInputRouter {
    var linkIsFound: ((ScoutArticle, Bool) -> Void)?
    fileprivate var parentNavigationController: UINavigationController!
    fileprivate let assembly: VoiceInputAssemlyProtocol
    
    required init(with assembly: VoiceInputAssemlyProtocol) {
        
        self.assembly = assembly
    }
}

extension VoiceInputRouter: VoiceInputRoutingProtocol{

    func show(from viewController: UIViewController, animated: Bool, userID: String) {
        
        let voiceInputVC = assembly.assemblyVoiceInputViewController()
        voiceInputVC.playerDelegate = self
        voiceInputVC.userID = userID
        self.showViewController(viewController: voiceInputVC, fromViewController: viewController, animated: animated)
    }
    
    // MARK: -
    // MARK: Private
    private func showViewController(viewController: UIViewController, fromViewController: UIViewController, animated: Bool) {
        
        if let navigationVC = fromViewController as? UINavigationController {
            
            if navigationVC.viewControllers.count == 0 { navigationVC.viewControllers = [viewController] }
            else { navigationVC.pushViewController(viewController, animated: animated) }
        }
        else {
            if let navigationVC = fromViewController.navigationController {
                
                if navigationVC.viewControllers.count == 0 { navigationVC.viewControllers = [viewController] }
                else { navigationVC.pushViewController(viewController, animated: animated) }
            }
            else {
                print("Unsupported navigation")
            }
        }
    }
}

extension VoiceInputRouter: VoiceInputDelegate {
    
    func openPlayer(withModel: ScoutArticle, isFullArticle: Bool) {
        self.linkIsFound!(withModel, isFullArticle)
    }
}
