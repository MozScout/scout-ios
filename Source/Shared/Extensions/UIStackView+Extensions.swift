//
//  UIStackView+Extensions.swift
//  Scout
//
//

import UIKit

extension UIStackView {
    func removeArrangedSubviews() {
        for subview in arrangedSubviews {
            subview.removeFromSuperview()
        }
    }

    func addArrangedSubviews(_ subviews: [UIView]) {
        for subview in subviews {
            addArrangedSubview(subview)
        }
    }

    func setArrangedSubviews(_ subviews: [UIView]) {
        removeArrangedSubviews()
        addArrangedSubviews(subviews)
    }
}
