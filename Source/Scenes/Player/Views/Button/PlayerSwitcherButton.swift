//
//  PlayerSwitcherButton.swift
//  Scout
//
//

import UIKit

class PlayerSwitcherButton: PlayerButton {

    // MARK: - Private properties

    private let switcher: Switcher = Switcher()

    // MARK: - Public properties

    public var isOn: Bool {
        get { return switcher.isOn }
        set { switcher.isOn = newValue }
    }

    // MAKR: -

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

        switcher.isEnabled = isEnabled
    }

    // MARK: - Private methods

    private func commonInit() {
        setupSwitcher()

        setupLayout()

        updateAppearance()
    }

    private func setupSwitcher() { }

    private func setupLayout() {
        setContent(switcher)
    }
}
