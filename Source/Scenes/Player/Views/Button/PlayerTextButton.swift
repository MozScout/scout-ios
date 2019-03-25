//
//  PlayerTextButton.swift
//  Scout
//
//

import UIKit

class PlayerTextButton: PlayerButton {

    // MARK: - Private properties

    private let valueLabel: UILabel = UILabel()

    // MARK: - Public properties

    public var value: String? {
        get { return valueLabel.text }
        set { valueLabel.text = newValue }
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

    override public func updateAppearance() {
        super.updateAppearance()

        if isEnabled {
            valueLabel.textColor = normalColor
        } else {
            valueLabel.textColor = disabledColor
        }
    }

    // MARK: - Private methods

    private func commonInit() {
        setupSpeedValueLabel()

        setupLayout()

        updateAppearance()
    }

    private func setupSpeedValueLabel() {
        valueLabel.font = UIFont.sfProDisplay(.bold, ofSize: 16)
        valueLabel.numberOfLines = 1
        valueLabel.textAlignment = .center
    }

    private func setupLayout() {
        setContent(valueLabel)
    }
}
