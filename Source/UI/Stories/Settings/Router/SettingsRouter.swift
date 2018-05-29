//
//  MainUIRouter.swift
//  Scout
//
//

import Foundation
import UIKit

class SettingsRouter {
    
    fileprivate var parentNavigationController: UINavigationController!
    fileprivate let assembly: SettingsAssemblyProtocol

    required init(with assembly: SettingsAssemblyProtocol) {
        
        self.assembly = assembly
    }
}

extension SettingsRouter: SettingsRoutingProtocol {
    
    func show(from viewController: UIViewController, animated: Bool) {
        
        let listVC = assembly.assemblySettingsViewController()
        
        self.showViewController(viewController: listVC, fromViewController: viewController, animated: animated)
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
