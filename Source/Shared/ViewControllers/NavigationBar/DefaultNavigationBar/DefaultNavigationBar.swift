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
        logoImageView.image = #imageLiteral(resourceName: "player_image")
    }

    private func setupFirstLeftItemContainer() {
        let settingsButton = UIButton()
        settingsButton.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
        settingsButton.setImage(#imageLiteral(resourceName: "I"), for: .normal)
        settingsButton.tintColor = UIColor.fxWoodsmoke
        setItem(settingsButton, to: firstLeftItemContainer)

        firstLeftItemContainer.backgroundColor = UIColor.clear
    }

    @objc private func settingsButtonAction() {
        onSettingsTap?()
    }

    private func setupSecondLeftItemContainer() {
        let handsFreeButton = UIButton()
        handsFreeButton.addTarget(self, action: #selector(handsFreeButtonAction), for: .touchUpInside)
        handsFreeButton.setImage(#imageLiteral(resourceName: "Hands Free"), for: .normal)
        handsFreeButton.tintColor = UIColor.fxWoodsmoke
        setItem(handsFreeButton, to: secondLeftItemContainer)

        secondLeftItemContainer.backgroundColor = UIColor.clear
    }

    @objc private func handsFreeButtonAction() {
        onHandsFreeTap?()
    }

    private func setupSecondRightItemContainer() {
        let searchButton = UIButton()
        searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        searchButton.setImage(#imageLiteral(resourceName: "Search"), for: .normal)
        searchButton.tintColor = UIColor.fxWoodsmoke
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
