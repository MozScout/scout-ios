//
//  VoiceInputRouter.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import Foundation
import UIKit

class PlayerRouter {
    
    var onBackButtonTap: (() -> Void)?
    var onMicrophoneButtonTap: (() -> Void)?
    fileprivate var parentNavigationController: UINavigationController!
    fileprivate let assembly: PlayerAssemlyProtocol
    
    required init(with assembly: PlayerAssemlyProtocol) {
        
        self.assembly = assembly
    }
}

extension PlayerRouter: PlayerRoutingProtocol{

    func show(from viewController: UIViewController, animated: Bool, fullLink: String) {
        
        let playerVC = assembly.assemblyPlayerViewController()
        playerVC.fullLink = fullLink
        playerVC.backButtonDelegate = self
        playerVC.microphoneButtonDelegate = self
        self.showViewController(viewController: playerVC, fromViewController: viewController, animated: animated)
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

extension PlayerRouter: PlayerViewControllerDelegate  {
    
    func backButtonTapped() {
        self.onBackButtonTap!()
    }
    
    func microphoneButtonTapped() {
        self.onMicrophoneButtonTap!()
    }
}
