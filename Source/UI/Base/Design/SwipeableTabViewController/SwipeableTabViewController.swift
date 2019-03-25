//
//  SwipableTabViewController.swift
//  Scout
//
//  Created by Michael Stegeman on 11/30/18.
//  Copyright © 2018 NIX. All rights reserved.
//

import Foundation
import UIKit

class SwipableTabViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let left = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        left.direction = .left
        self.view.addGestureRecognizer(left)

        let right = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        right.direction = .right
        self.view.addGestureRecognizer(right)
    }

    @objc
    func swipeLeft() {
        let oldIndex = self.tabBarController!.selectedIndex
        let total = self.tabBarController!.viewControllers!.count - 1
        let newIndex = min(total, oldIndex + 1)

        if oldIndex != newIndex {
            self.tabBarController!.selectedIndex = newIndex

            let transition = CATransition()
            transition.type = .push
            transition.subtype = .fromRight
            transition.duration = 0.2
            transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
            self.tabBarController!.selectedViewController!.view.layer.add(transition, forKey: "fadeTransition")
        }
    }

    @objc
    func swipeRight() {
        let oldIndex = self.tabBarController!.selectedIndex
        let newIndex = max(0, self.tabBarController!.selectedIndex - 1)

        if oldIndex != newIndex {
            self.tabBarController!.selectedIndex = newIndex

            let transition = CATransition()
            transition.type = .push
            transition.subtype = .fromLeft
            transition.duration = 0.2
            transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
            self.tabBarController!.selectedViewController!.view.layer.add(transition, forKey: "fadeTransition")
        }
    }
}
