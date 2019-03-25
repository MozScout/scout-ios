//
//  UIView+Fade.swift
//  Scout
//
//

import UIKit

extension UIView {
    func fadeIn(duration: TimeInterval) {
        guard !isHidden else {
            return
        }

        UIView.animate(
            withDuration: duration,
            animations: {
                self.alpha = 0
        },
            completion: { _ in
                self.isHidden = true
        }
        )
    }

    func fadeOut(duration: TimeInterval) {
        guard isHidden else {
            return
        }

        UIView.animate(
            withDuration: duration,
            animations: {
                self.isHidden = false
                self.alpha = 1
        }
        )
    }
}
