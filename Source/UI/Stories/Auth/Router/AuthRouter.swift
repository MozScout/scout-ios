//
//  MainUIRouter.swift
//  Scout
//
//

import Foundation
import UIKit

class AuthRouter {
    
    fileprivate var parentNavigationController: UINavigationController!
    fileprivate let assembly: AuthAssemblyProtocol

    required init(with assembly: AuthAssemblyProtocol) {
        
        self.assembly = assembly
    }
}

extension AuthRouter: AuthRoutingProtocol {
    
    func show(from viewController: UIViewController, animated: Bool) {
        
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

