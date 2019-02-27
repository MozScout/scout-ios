//
//  NavigationBarContainerController.swift
//  Scout
//
//

import UIKit

class NavigationBarContainerController: UIViewController {

    // MARK: - Private properties
    
    @IBOutlet private weak var navigationBarView: NavigationBarView!
    @IBOutlet private weak var containerView: UIView!

    private(set) var navigationBarHidden: Bool = false
    private var content: UIViewController?

    // MARK: - Overridden

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarView.backgroundColor = UIColor.red
    }

    // MARK: - Public methods

    func navigationBarIntersectionRectIn(view: UIView) -> CGRect {
        let converted = view.convert(navigationBarView.bounds, from: navigationBarView)
        let intersection = view.bounds.intersection(converted)
        return intersection.isNull ? CGRect.zero : intersection
    }

    func setContent(_ newContent: UIViewController) {
        removePreviousContent(content)
        addNewContent(newContent)
        content = newContent
    }

    // MARK: - Private methods

    private func addNewContent(_ content: UIViewController?) {
        guard let newContent = content else { return }
        self.addChildViewController(newContent, to: containerView)
    }

    private func removePreviousContent(_ content: UIViewController?) {
        guard let prev = content else { return }
        self.remove(childController: prev)
    }
}

extension UIViewController {
    private var navigationBarContainer: NavigationBarContainerController? {
        var currentParent: UIViewController? = self.parent
        while currentParent != nil {
            if let navigationBarContainer = currentParent as? NavigationBarContainerController {
                return navigationBarContainer
            }

            currentParent = currentParent?.parent
        }
        return nil
    }

    func navigationBarRectIn(view: UIView) -> CGRect {
        return self.navigationBarContainer?.navigationBarIntersectionRectIn(view: view) ?? CGRect.zero
    }

    func topOverlayHeight(view: UIView) -> CGFloat {
        if self.navigationBarContainer?.navigationBarHidden ?? true {
            if #available(iOS 11.0, *) {
                return view.safeAreaInsets.top
            } else {
                return topLayoutGuide.length
            }
        } else {
            let navigationBarHeight = self.navigationBarRectIn(view: view).height
            return navigationBarHeight
        }
    }
}
