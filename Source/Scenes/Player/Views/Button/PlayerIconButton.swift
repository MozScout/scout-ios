//
//  PlayerIconButton.swift
//  Scout
//
//

import UIKit

class PlayerIconButton: PlayerButton {

    // MARK: - Private properties

    private let iconView: UIImageView = UIImageView()

    // MARK: - Public properties

    public var icon: UIImage? {
        get { return iconView.image }
        set { iconView.image = newValue }
    }

    // MARK: -

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    override func updateAppearance() {
        super.updateAppearance()

        if isEnabled {
            iconView.tintColor = normalColor
        } else {
            iconView.tintColor = disabledColor
        }
    }

    // MARK: - Private methods

    private func commonInit() {
        setupIconView()

        setupLayout()
    }

    private func setupIconView() {
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = UIColor.fxScienceBlue
    }

    private func setupLayout() {
        setContent(iconView)
    }
}
