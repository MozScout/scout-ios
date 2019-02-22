//
//  TabBarItemView.swift
//  Scout
//
//

import UIKit

class TabBarItemView: UIView {

    typealias OnSelected = (TabBarItemView) -> Void

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

    private let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    private let isEnabled: Bool = true

    // MARK: - Public properties

    public var isSelected: Bool = false {
        didSet {
            updateSelectedState()
        }
    }

    public var onSelected: OnSelected = { (_) in }

    // MARK: - Overridden methods

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    // MARK: - Private methods

    private func setup() {
        setupTapGestureRecognizer()
        setupView()
        setupIconView()
        setupTitleLabel()

        updateSelectedState()
    }

    private func setupTapGestureRecognizer() {
        tapGestureRecognizer.addTarget(self, action: #selector(tapGestureRecognizerAction))
    }

    @objc private func tapGestureRecognizerAction() {
        if isEnabled {
            onSelected(self)
        }
    }

    private func setupView() {
        addGestureRecognizer(tapGestureRecognizer)
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
