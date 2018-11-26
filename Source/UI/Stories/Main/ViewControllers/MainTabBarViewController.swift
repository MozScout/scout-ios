//
//  MainTabBarViewController.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/9/18.
//

import Foundation
import UIKit

class MainTabBarViewController: UITabBarController {
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.configureTabBarHeight()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = Design.Color.darkWhite
        tabBar.isTranslucent = false
    }

    fileprivate func configureTabBarHeight() {
        let newTabBarHeight = defaultTabBarHeight

        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight

        tabBar.frame = newFrame
    }
}
