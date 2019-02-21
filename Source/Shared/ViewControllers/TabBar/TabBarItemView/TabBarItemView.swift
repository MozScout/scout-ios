//
//  TabBarItemView.swift
//  Scout
//
//

import UIKit

class TabBarItemView: UIView {

    struct Model {
        let title: String
        let icon: UIImage
    }

    // MARK: - Private properties

    private let titleFont: UIFont = UIFont.systemFont(ofSize: 10, weight: .regular)
    private let selectedColor: UIColor = UIColor("FF3858")!
    private let notSelectedColor: UIColor = UIColor("737373")!

    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Public properties

    public var isSelected: Bool = false {
        didSet {
            updateSelectedState()
        }
    }

    // MARK: - Overridden methods

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    // MARK: - Private methods

    private func setup() {
        setupView()
        setupIconView()
        setupTitleLabel()

        updateSelectedState()
    }

    private func setupView() {

    }

    private func setupIconView() {
        iconView.contentMode = .scaleAspectFit
    }

    private func setupTitleLabel() {
        titleLabel.font = titleFont
        titleLabel.textAlignment = .center
    }

    private func updateSelectedState() {
        let color = isSelected ? selectedColor : notSelectedColor
        iconView.tintColor = color
        titleLabel.textColor = color
    }

    // MARK: - Public methods

    public func setup(with model: Model) {
        iconView.image = model.icon
        titleLabel.text = model.title
    }
}
