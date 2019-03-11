//
//  NavigationBarContainerController.swift
//  Scout
//
//

import UIKit

protocol NavigationBarContainerContent {
    typealias OnScrollViewDidScroll = (_ scrollView: UIScrollView) -> Void

    var onScrollViewDidScroll: OnScrollViewDidScroll? { get set }
}

class NavigationBarContainerController: UIViewController {

    typealias ContentController = UIViewController & NavigationBarContainerContent

    // MARK: - Private properties
    
    @IBOutlet private weak var navigationBarContainerView: NavigationBarContainerView!
    @IBOutlet private weak var containerView: UIView!

    private(set) var navigationBarHidden: Bool = false
    private var content: ContentController?

    private var contentInset: UIEdgeInsets = .zero
    private var previousContentOffset: CGPoint = .zero
    private var contentOffset: CGPoint = .zero {
        didSet {
            previousContentOffset = oldValue
        }
    }

    // MARK: - Public properties

    public var hidesNavigationBarOnScroll: Bool = false {
        didSet {
            updateHeaderLayout()
        }
    }

    // MARK: - Public methods

    func navigationBarIntersectionRectIn(view: UIView) -> CGRect {
        var bounds = navigationBarContainerView.bounds
        let difference = navigationBarContainerView.expandedHeight - navigationBarContainerView.currentHeight
        bounds.size.height += difference
        let converted = view.convert(bounds, from: navigationBarContainerView)
        let intersection = view.bounds.intersection(converted)
        return intersection.isNull ? CGRect.zero : intersection
    }

    func setContent(_ newContent: ContentController) {
        removePreviousContent(content)

        content = newContent
        content?.onScrollViewDidScroll = { [weak self] (scrollView) in
            self?.contentInset = scrollView.contentInset
            self?.contentOffset = scrollView.contentOffset
            self?.updateHeaderLayout()
        }

        contentInset = .zero
        contentOffset = .zero
        previousContentOffset = .zero
        updateHeaderLayout()

        addNewContent(newContent)
    }

    func setNavigationBarContent(_ content: UIView) {
        navigationBarContainerView.setContent(content)
    }

    // MARK: - Private methods

    private func addNewContent(_ content: UIViewController?) {
        guard let newContent = content else { return }
        addChildViewController(newContent, to: containerView)
    }

    private func removePreviousContent(_ content: UIViewController?) {
        guard let prev = content else { return }
        remove(childController: prev)
    }

    private func updateHeaderLayout() {
        let currentConstant: CGFloat = navigationBarContainerView.currentConstant

        let newConstant: CGFloat = {
            if hidesNavigationBarOnScroll {
                var contentOffset = self.contentOffset.y
                var previousContentOffset = self.previousContentOffset.y

                if contentOffset < -contentInset.top {
                    contentOffset = -contentInset.top
                }

                if previousContentOffset < -contentInset.top {
                    previousContentOffset = -contentInset.top
                }

                let offsetDifference = previousContentOffset - contentOffset
                let constraintMinimum: CGFloat = navigationBarContainerView.contentHeight
                let constraintMaximum: CGFloat = 0

                var newConstant: CGFloat = currentConstant + offsetDifference
                newConstant = max(newConstant, constraintMaximum)
                newConstant = min(newConstant, constraintMinimum)
                return newConstant
            } else {
                return navigationBarContainerView.contentHeight
            }
        }()

        guard newConstant != currentConstant else { return }
        navigationBarContainerView.set(newConstant)
    }
}

extension UIViewController {
    var navigationBarContainer: NavigationBarContainerController? {
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
