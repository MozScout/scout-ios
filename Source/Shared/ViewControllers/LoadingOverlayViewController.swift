//
//  LoadingOverlayViewController.swift
//  Scout
//
//

import UIKit

class LoadingOverlayViewController: UIViewController {

    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    // MARK: - Overridden methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupActivityIndicator()
        setupLayout()
    }

    // MARK: - Public methods

    func startLoading() {
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
    }

    // MARK: - Private methods

    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }

    private func setupActivityIndicator() {
        activityIndicator.style = .whiteLarge
    }

    private func setupLayout() {
        view.addSubview(activityIndicator)

        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
