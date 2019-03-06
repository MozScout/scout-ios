//
//  DefaultNavigationBar.swift
//  Scout
//
//

import UIKit

class DefaultNavigationBar: UIView {

    // MARK: - Private properties

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var firstLeftItemContainer: UIView!
    @IBOutlet private weak var secondLeftItemContainer: UIView!
    @IBOutlet private weak var secondRightItemContainer: UIView!
    @IBOutlet private weak var firstRightItemContainer: UIView!

    private var firstRightItem: UIView?

    // MARK: - Public properties

    public var onSettingsTap: (() -> Void)?
    public var onSearchTap: (() -> Void)?
    public var onHandsFreeTap: (() -> Void)?

    // MARK: -

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
        setupLogoImageView()
        setupFirstLeftItemContainer()
        setupSecondLeftItemContainer()
        setupSecondRightItemContainer()
        setupFirstRightItemContainer()
    }

    // MARK: - Public methods

    public func setRightItem(_ item: UIView) {
        firstRightItem?.removeFromSuperview()
        setItem(item, to: firstRightItemContainer)
        firstRightItem = item
    }

    // MARK: - Private methods

    private func setupView() {
        backgroundColor = UIColor.clear
    }

    private func setupLogoImageView() {
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage.fxLogo
    }

    private func setupFirstLeftItemContainer() {
        let settingsButton = UIButton.settingsButton
        settingsButton.addTarget(
            self,
            action: #selector(settingsButtonAction),
            for: .touchUpInside
        )
        setItem(settingsButton, to: firstLeftItemContainer)

        firstLeftItemContainer.backgroundColor = UIColor.clear
    }

    @objc private func settingsButtonAction() {
        onSettingsTap?()
    }

    private func setupSecondLeftItemContainer() {
        let handsFreeButton = UIButton.handsFreeButton
        handsFreeButton.addTarget(
            self,
            action: #selector(handsFreeButtonAction),
            for: .touchUpInside
        )
        setItem(handsFreeButton, to: secondLeftItemContainer)

        secondLeftItemContainer.backgroundColor = UIColor.clear
    }

    @objc private func handsFreeButtonAction() {
        onHandsFreeTap?()
    }

    private func setupSecondRightItemContainer() {
        let searchButton = UIButton.searchButton
        searchButton.addTarget(
            self,
            action: #selector(searchButtonAction),
            for: .touchUpInside
        )
        setItem(searchButton, to: secondRightItemContainer)

        secondRightItemContainer.backgroundColor = UIColor.clear
    }

    @objc private func searchButtonAction() {
        onSearchTap?()
    }

    private func setupFirstRightItemContainer() {
        firstRightItemContainer.backgroundColor = UIColor.clear
    }

    private func setItem(_ item: UIView, to container: UIView) {
        container.addSubview(item)
        item.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

private extension UIButton {
    class var settingsButton: UIButton {
        let settingsButton = UIButton.navigationBarButton
        settingsButton.setImage(UIImage.fxSettingsNavigationBarIcon, for: .normal)
        return settingsButton
    }

    class var handsFreeButton: UIButton {
        let handsFreeButton = UIButton.navigationBarButton
        handsFreeButton.setImage(UIImage.fxHandsFreeNavigationBarIcon, for: .normal)
        return handsFreeButton
    }

    class var searchButton: UIButton {
        let searchButton = UIButton.navigationBarButton
        searchButton.setImage(UIImage.fxSearchNavigationBarIcon, for: .normal)
        return searchButton
    }

    private class var navigationBarButton: UIButton {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.fxWoodsmoke
        return button
    }
}
