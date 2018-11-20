//
//  MainAssembly.swift
//  Scout
//
//

import Foundation
import UIKit

class MainAssembly: MainAssemblyProtocol {
    fileprivate let applicationAssembly: ApplicationAssemblyProtocol

    required init(withAssembly assembly: ApplicationAssemblyProtocol) {
        self.applicationAssembly = assembly
    }

    func assemblyMainTabBarViewController(viewControllers: [UIViewController]) -> MainTabBarViewController {
        let tabbarVC = self.storyboard.instantiateViewController(
            // swiftlint:disable:next force_cast
            withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        tabbarVC.setViewControllers(viewControllers, animated: false)

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Design.Color.black],
                                                         for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Design.Color.red],
                                                         for: .selected)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)

        return tabbarVC
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension MainAssembly {
    var storyboard: UIStoryboard { return UIStoryboard(name: "Main", bundle: nil) }
}
