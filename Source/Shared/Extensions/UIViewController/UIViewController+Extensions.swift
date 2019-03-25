//
//  UIViewController+Extensions.swift
//  Scout
//
//

import UIKit

extension UIViewController {

    // MARK: - Child view controllers -

    func addChildViewController(_ childController: UIViewController, to containerView: UIView) {
        addChild(childController)
        containerView.addSubview(childController.view)
        childController.view.frame = containerView.bounds
        childController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childController.didMove(toParent: self)
    }

    func remove(childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }

    // MARK: - Traverse -

    func findParentOrPresenting<Controller: UIViewController>() -> Controller? {
        var current: UIViewController? = self
        while let parent = current?.parent ?? current?.presentingViewController {
            if let controller = parent as? Controller {
                return controller
            }

            current = parent
        }
        return nil
    }
}
