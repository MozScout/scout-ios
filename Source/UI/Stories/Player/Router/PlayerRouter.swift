//
//  VoiceInputRouter.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import Foundation
import UIKit

class PlayerRouter {
    fileprivate var parentNavigationController: UINavigationController!
    fileprivate let assembly: PlayerAssemlyProtocol
    
    required init(with assembly: PlayerAssemlyProtocol) {
        
        self.assembly = assembly
    }
}

extension PlayerRouter: PlayerRoutingProtocol{

    func show(from viewController: UIViewController, animated: Bool, link: String) {
        
        let playerVC = assembly.assemblyPlayerViewController()
        playerVC.link = link
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
