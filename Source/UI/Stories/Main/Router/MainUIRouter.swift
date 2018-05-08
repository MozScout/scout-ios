//
//  MainUIRouter.swift
//  Scout
//
//

import Foundation
import UIKit

class MainUIRouter {
    
    fileprivate var parentNavigationController: UINavigationController!
    fileprivate let assembly: MainAssemblyProtocol
    fileprivate var selectedTab: MainTab = .profile

    required init(with assembly: MainAssemblyProtocol) {
        
        self.assembly = assembly
    }
}

extension MainUIRouter: MainRoutingProtocol {
    
    func show(from viewController: UIViewController, animated: Bool) {
        
        let tab = MainTab.profile
        
        if let navigationController = viewController as? UINavigationController {
            
            self.parentNavigationController = navigationController
            self.showInitialUI(for: tab, in: navigationController, animated: false)
        }
        else {
            print("Unsupported navigation")
        }
    }
}

// MARK: -
// MARK: Private
fileprivate extension MainUIRouter {
    
    fileprivate func showInitialUI(for tab: MainTab,
                   in navigationController: UINavigationController,
                                  animated: Bool = true) {
        
        let mainVC = self.assembly.assemblyMainViewController()
        navigationController.viewControllers = [mainVC]
        
        
        self.selectedTab = tab
        
        switch tab {
        case .profile: break
            
//            let router = assembly.assemblyProfileRouter()
        }
    }
}
