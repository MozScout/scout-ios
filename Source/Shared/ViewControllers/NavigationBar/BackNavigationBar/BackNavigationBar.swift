//
//  BackNavigationBar.swift
//  Scout
//
//

import UIKit

class BackNavigationBar: UIView {

    // MARK: - Private properties

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Public properties

    public var onBack: (() -> Void)?
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    // MARK: -

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
        setupBackButton()
        setupTitleLabel()
    }

    // MARK: - Private methods

    private func setupView() {
        backgroundColor = UIColor.clear
    }

    private func setupBackButton() {
        backButton.tintColor = UIColor.fxWoodsmoke
        backButton.adjustsImageWhenHighlighted = true
        backButton.setImage(#imageLiteral(resourceName: "Back"), for: .normal)
        backButton.addTarget(
            self,
            action: #selector(backButtonAction),
            for: .touchUpInside
        )
    }

    @objc private func backButtonAction() {
        onBack?()
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.sfProText(.semibold, ofSize: 18)
        titleLabel.textColor = UIColor.fxBlack
        titleLabel.textAlignment = .center
    }

    // MARK: - Public methods
}
