//
//  UIViewController+Loading.swift
//  Scout
//
//

import UIKit

extension UIView {

    private static var activityIndicatorKey = "activityIndicator"

    func showLoading(tintColor: UIColor = UIColor.gray) {
        let activityIndicator: UIActivityIndicatorView

        if let indicator = objc_getAssociatedObject(self, &UIView.activityIndicatorKey) as? UIActivityIndicatorView {
            activityIndicator = indicator
        } else {
            activityIndicator = UIActivityIndicatorView()
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = .whiteLarge
            addSubview(activityIndicator)

            activityIndicator.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }

        bringSubviewToFront(activityIndicator)
        activityIndicator.color = tintColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false

        objc_setAssociatedObject(self, &UIView.activityIndicatorKey, activityIndicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func hideLoading() {
        guard let activityIndicator = objc_getAssociatedObject(self, &UIView.activityIndicatorKey) as? UIActivityIndicatorView else {
            return
        }

        activityIndicator.stopAnimating()
        self.isUserInteractionEnabled = true
    }
}
