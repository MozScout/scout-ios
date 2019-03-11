//
//  KeyboardController.swift
//  Scout
//
//

import UIKit

private extension UIView.AnimationCurve {
    var animationOptions: UIView.AnimationOptions {
        return UIView.AnimationOptions(rawValue: UInt(self.rawValue))
    }
}

extension UIView {
    static func animate(
        withKeyboardAttributes attributes: KeyboardAttributes,
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
        ) {

        UIView.animate(
            withDuration: attributes.animationDuration,
            delay: 0,
            options: attributes.animationCurve.animationOptions,
            animations: animations,
            completion: completion
        )
    }
}

struct KeyboardAttributes {
    let rectInWindow: CGRect
    let animationDuration: TimeInterval
    let animationCurve: UIView.AnimationCurve

    func heightIn(view: UIView) -> CGFloat {
        let convertedRect = view.convert(self.rectInWindow, from: view.window)

        var heightInView: CGFloat = view.bounds.height - convertedRect.minY
        if heightInView < 0 {
            heightInView = 0
        }

        return heightInView
    }

    func heightInContainerView(_ container: UIView, view: UIView) -> CGFloat {
        let keyboardHeightInContainer: CGFloat = self.heightIn(view: container)
        let minKeyboardY = container.bounds.height - keyboardHeightInContainer
        let maxViewY = view.frame.maxY
        let keyboardHeightInView = max(0, maxViewY - minKeyboardY)
        return keyboardHeightInView
    }

    func showingIn(view: UIView) -> Bool {
        return self.heightIn(view: view) > 0.0
    }
}

struct KeyboardObserver: Equatable {

    weak var observer: AnyObject?
    let keyboardWillChange: ((_ attributes: KeyboardAttributes) -> Void)?

    // MARK: -

    init(_ observer: AnyObject?) {
        self.init(observer, keyboardWillChange: nil)
    }

    init(_ observer: AnyObject?, keyboardWillChange: ((_ attributes: KeyboardAttributes) -> Void)?) {
        self.observer = observer
        self.keyboardWillChange = keyboardWillChange
    }

    // MARK: - Equatable

    static func ==(left: KeyboardObserver, right: KeyboardObserver) -> Bool {
        return left.observer === right.observer
    }
}

class KeyboardController {

    // MARK: - Properties

    private var observers: [KeyboardObserver] = [KeyboardObserver]()
    public private(set) var attributes: KeyboardAttributes? = nil

    static let shared = KeyboardController()

    // MARK: - Public

    func add(observer: KeyboardObserver) {
        if !self.observers.contains(observer) {
            self.observers.append(observer)
            if let attributes = self.attributes {
                observer.keyboardWillChange?(attributes)
            }
        }
    }

    func remove(observer: KeyboardObserver) {
        if let index: Int = self.observers.index(of: observer) {
            self.observers.remove(at: index)
        }
    }

    // MARK: - Private

    private init() {
        self.subscribeForKeyboard()
    }

    private func subscribeForKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    private func handleKeyboardAttributes(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
        }
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0
        let curveRawValue: UIView.AnimationCurve.RawValue = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue ?? UIView.AnimationCurve.linear.rawValue
        let curve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: curveRawValue) ?? UIView.AnimationCurve.linear

        let attributes = KeyboardAttributes(
            rectInWindow: keyboardRect,
            animationDuration: duration,
            animationCurve: curve
        )
        self.attributes = attributes

        let allObservers = self.observers
        for observer in allObservers {
            if observer.observer == nil {
                if let index: Int = self.observers.index(of: observer) {
                    self.observers.remove(at: index)
                }
            } else {
                observer.keyboardWillChange?(attributes)
            }
        }
    }

    // MARK: - Notifications

    @objc private func keyboardWillChange(notification: Notification) {
        self.handleKeyboardAttributes(notification: notification)
    }
}

