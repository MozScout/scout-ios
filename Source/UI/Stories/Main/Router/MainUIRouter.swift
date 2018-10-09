//
//  MainUIRouter.swift
//  Scout
//
//

import Foundation
import UIKit

class MainUIRouter: NSObject {
    
    fileprivate var parentNavigationController: UINavigationController!
    fileprivate var tabbar: MainTabBarViewController!
    fileprivate let assembly: MainAssemblyProtocol
    fileprivate var selectedTab: MainTab = .articles
    var onMicrophoneButtonTap: (() -> Void)?
    var userID: String = ""
    // Routers
    fileprivate let myListRouter: MyListRoutingProtocol
    fileprivate let podcastsRouter: PodcastsRoutingProtocol
    fileprivate var helpRouter: HelpRoutingProtocol
    fileprivate var settingsRouter: SettingsRoutingProtocol

    required init(withApplicationAssembly applicationAssembly: ApplicationAssemblyProtocol, assembly: MainAssemblyProtocol) {
        
        self.assembly = assembly
        
        // Routers init
        self.myListRouter = applicationAssembly.assemblyMyListRouter()
        self.helpRouter = applicationAssembly.assemblyHelpRouter()
        self.settingsRouter = applicationAssembly.assemblySettingsRouter()
        self.podcastsRouter = applicationAssembly.assemblyPodcastsRouter()
    }
}

extension MainUIRouter: MainRoutingProtocol, UITabBarControllerDelegate {
    
    func showMainUIInterface(fromViewController viewController: UINavigationController, animated: Bool) {
        
        let tabs: [MainTab] = [.podcasts, .articles, .settings]
        var tabViewControllers: [UIViewController] = []
        
        for curTab in tabs {
            
            let currentTabViewController = self.assemblyNavigationController(forTab: curTab)
            tabViewControllers.append(currentTabViewController)
        }
        
        let tabbarVC = assembly.assemblyMainTabBarViewController(viewControllers: tabViewControllers)
        tabbarVC.delegate = self
        tabbarVC.microphoneButtonDelegate = self
        
        self.tabbar = tabbarVC
        
        viewController.viewControllers = [tabbarVC]
        parentNavigationController = viewController
        
    }
    
    func showMainUITab(tab: MainTab, animated:Bool) {
        
        if self.tabbar != nil {
            self.selectMainUITab(tab: tab)
        }
    }
}

// MARK: -
// MARK: Private
fileprivate extension MainUIRouter {
    
    fileprivate func showInitialUI(for tab: MainTab,
                   in navigationController: UINavigationController,
                                  animated: Bool) {
        
        switch tab {
        case .podcasts:
            podcastsRouter.show(from: navigationController, animated: animated, withUserID: self.userID)
        case .articles:
            myListRouter.show(from: navigationController, animated: animated, withUserID: self.userID)
        case .settings:
            settingsRouter.show(from: navigationController, animated: animated)
       // case .audioAction:
           // print("touch action button")
        }
    }
    
    private func assemblyNavigationController(forTab tab: MainTab) -> UINavigationController {
        
        let tabbarItem = self.tabbarItem(forTab: tab)
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        navigationController.tabBarItem = tabbarItem
        navigationController.tabBarItem.tag = tab.rawValue
        
        self.showInitialUI(for: tab, in: navigationController, animated: false)
        
        return navigationController
    }
    
    private func tabbarItem(forTab tab: MainTab) -> UITabBarItem {
        
        func originalImageUsingImageName(imageName name: String) -> UIImage? {
            
            guard let requiredOriginalImage = UIImage(named: name) else { return nil }
            return requiredOriginalImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }
        
        switch tab {
        case .podcasts:
            return UITabBarItem(title: "Podacts",
                               image: originalImageUsingImageName(imageName: "icn_podcasts"),
                       selectedImage: originalImageUsingImageName(imageName: "icn_podcasts_selected"))
            
        case .articles:
            return UITabBarItem(title: "Articles",
                                image: originalImageUsingImageName(imageName: "icn_play"),
                                selectedImage: originalImageUsingImageName(imageName: "icn_play_selected"))
        case .settings:
            return UITabBarItem(title: "Settings",
                               image: originalImageUsingImageName(imageName: "icn_settings"),
                       selectedImage: originalImageUsingImageName(imageName: "icn_settings_selected"))
        }
    }
    
    // MARK: Tabbar
    private func selectedMainTab() -> MainTab {
        
        let selectedTabIndex = self.tabbar.selectedIndex
        let UITab = MainTab(rawValue: selectedTabIndex)!
        return UITab
    }
    
    private func selectMainUITab(tab: MainTab) {
        
        self.tabbar.selectedIndex = tab.rawValue
    }
    
    private func currentSelectedNavigationController() -> UINavigationController {
        
        return self.navigationController(forMainUITab: self.selectedMainTab())
    }
    
    private func navigationController(forMainUITab tab: MainTab) -> UINavigationController {
        
        let tabIndex = tab.rawValue
        return tabbar.viewControllers![tabIndex] as! UINavigationController
    }
    
    // MARK: UITabBarControllerDelegate
    fileprivate func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}

extension MainUIRouter: MainTabBarViewControllerDelegate {
    
    func mainTabBarViewController(viewController: MainTabBarViewController, didTouchMicrophoneButton button: UIButton) {
        self.onMicrophoneButtonTap!()
        print("Did touch Microphone Button")
    }
}







