//
//  TabBarContainerController.swift
//  Scout
//
//

import UIKit

class TabBarContainerController: UIViewController {

    struct Item {
        let title: String
        let icon: UIImage
        let onSelect: () -> Void
    }

    // MARK: - Private properties

    @IBOutlet private weak var tabBarView: TabBarView!
    @IBOutlet private weak var containerView: UIView!

    private var content: UIViewController?
    private var selectedIndex: Int? = nil

    // MARK: - Public properties

    public var selectedItemIndex: Int? {
        return tabBarView.selectedItemIndex
    }

    private(set) var tabBarHidden: Bool = false

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func setItems(_ items: [Item], selectedIndex: Int?) {
        let tabBarViewItems = items.map { (item) -> TabBarView.Item in
            return TabBarView.Item(
                title: item.title,
                icon: item.icon,
                onSelect: item.onSelect
            )
        }

        tabBarView.setItems(tabBarViewItems, selectedIndex: selectedIndex)
    }

    public func transitionToContent(
        _ newContent: UIViewController?,
        at index: Int?,
        animated: Bool
        ) {

        let direction = getDirection(
            from: selectedIndex,
            to: index
        )

        let previousContent: UIViewController? = content

        addNewContent(newContent)
        content = newContent

        animateTransition(
            from: previousContent,
            to: newContent,
            with: direction,
            animated: animated,
            completion: { [weak self] in
                self?.removePreviousContent(previousContent)
                self?.selectedIndex = index
        })
    }

    func tabBarIntersectionRectIn(view: UIView) -> CGRect {
        let converted = view.convert(tabBarView.bounds, from: tabBarView)
        let intersection = view.bounds.intersection(converted)
        return intersection.isNull ? CGRect.zero : intersection
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

    private enum TransitionDirection {
        case fromLeft
        case fromRight
        case fade
    }
    private func getDirection(
        from: Int?,
        to: Int?
        ) -> TransitionDirection {

        guard let from = from, let to = to else {
            return .fade
        }

        if from < to { return .fromRight }
        else if from > to { return .fromLeft }
        else { return .fade }
    }

    private func animateTransition(
        from previousContent: UIViewController?,
        to newContent: UIViewController?,
        with direction: TransitionDirection,
        animated: Bool,
        completion: @escaping () -> Void
        ) {

        guard animated else {
            completion()
            return
        }

        switch direction {

        case .fade:
            animateFade(
                from: previousContent,
                to: newContent,
                completion: completion
            )

        case .fromLeft,
             .fromRight:
            animateSlide(
                from: previousContent,
                to: newContent,
                completion: completion,
                fromRight: direction == .fromRight
            )
        }
    }

    private func animateFade(
        from previousContent: UIViewController?,
        to newContent: UIViewController?,
        completion: @escaping () -> Void
        ) {

        newContent?.view.alpha = 0.0

        let duration = TimeInterval(UINavigationController.hideShowBarDuration)
        self.tabBarView.isUserInteractionEnabled = false
        UIView.animate(
            withDuration: duration,
            animations: {
                previousContent?.view.alpha = 0.0
                newContent?.view.alpha = 1.0
        },
            completion: { _ in
                previousContent?.view.alpha = 1.0
                completion()
                self.tabBarView.isUserInteractionEnabled = true
        })
    }

    private func animateSlide(
        from previousContent: UIViewController?,
        to newContent: UIViewController?,
        completion: @escaping () -> Void,
        fromRight: Bool
        ) {

        let frameOnLeft = CGRect(
            x: -containerView.bounds.width, y: 0.0,
            width: containerView.bounds.width, height: containerView.bounds.height
        )
        let frameOnRight = CGRect(
            x: containerView.bounds.width, y: 0.0,
            width: containerView.bounds.width, height: containerView.bounds.height
        )

        let setupInitialNewView: ((_ view: UIView?) -> Void) = { view in
            guard let view = view else { return }

            if fromRight {
                view.frame = frameOnRight
            } else {
                view.frame = frameOnLeft
            }
        }
        let setupTargetNewView: ((_ view: UIView?) -> Void) = { view in
            guard let view = view else { return }
            view.frame = self.containerView.bounds
        }
        let setupTargetPreviousView: ((_ view: UIView?) -> Void) = { view in
            guard let view = view else { return }

            if fromRight {
                view.frame = frameOnLeft
            } else {
                view.frame = frameOnRight
            }
        }

        setupInitialNewView(newContent?.view)
        self.containerView.layoutIfNeeded()

        let duration = TimeInterval(UINavigationController.hideShowBarDuration)
        self.tabBarView.isUserInteractionEnabled = false
        UIView.animate(
            withDuration: duration,
            animations: {
                setupTargetNewView(newContent?.view)
                setupTargetPreviousView(previousContent?.view)
        },
            completion: { _ in
                completion()
                self.tabBarView.isUserInteractionEnabled = true
        })
    }
}

extension TabBarContainerController: RootContentProtocol {
    func getRootContentViewController() -> UIViewController {
        return self
    }
}

extension UIViewController {
    private var tabBarContainer: TabBarContainerController? {
        var currentParent: UIViewController? = self.parent
        while currentParent != nil {
            if let tabBarContainer = currentParent as? TabBarContainerController {
                return tabBarContainer
            }

            currentParent = currentParent?.parent
        }
        return nil
    }

    func tabBarRectIn(view: UIView) -> CGRect {
        return self.tabBarContainer?.tabBarIntersectionRectIn(view: view) ?? CGRect.zero
    }

    func bottomOverlayHeight(view: UIView) -> CGFloat {
        if self.tabBarContainer?.tabBarHidden ?? true {
            if #available(iOS 11.0, *) {
                return view.safeAreaInsets.bottom
            } else {
                return 0.0
            }
        } else {
            let tabBarHeight = self.tabBarRectIn(view: view).height
            return tabBarHeight
        }
    }
}
