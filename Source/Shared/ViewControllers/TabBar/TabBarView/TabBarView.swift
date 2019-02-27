//
//  TabBarView.swift
//  Scout
//
//

import UIKit

class TabBarView: UIView {

    struct Item {
        let title: String
        let icon: UIImage
        let onSelect: () -> Void
    }

    typealias OnSelectedItem = (Int) -> Void

    private let background: UIColor = UIColor("F9F9FA")!.withAlphaComponent(0.95)
    private let separator: UIColor = UIColor("D7D7DB")!

    // MARK: - Private properties

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var stackView: UIStackView!

    private var itemViews: [TabBarItemView] = []

    // MARK: - Public properties

    public private(set) var selectedItemIndex: Int? {
        didSet {
            updateSelectedItem()
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 61)
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
        setupSeparatorView()
    }

    private func setup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds

        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(contentView)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Cannot get view from nib")
        }

        return view
    }

    // MARK: - Public methods

    public func setItems(_ items: [Item], selectedIndex: Int?) {
        itemViews = items.enumerated().map { [weak self] (itemTuple) -> TabBarItemView in
            let item = itemTuple.element
            let index = itemTuple.offset

            let model = TabBarItemView.Model(
                title: item.title,
                icon: item.icon
            )

            let view = TabBarItemView.loadFromNib()
            view.setup(with: model)
            view.onSelected = { [weak self] (_) in
                self?.selectedItemIndex = index
                item.onSelect()
            }
            return view
        }
        stackView.setArrangedSubviews(itemViews)

        if 0..<itemViews.count ~= (selectedIndex ?? -1) {
            selectedItemIndex = selectedIndex
        }
    }

    // MARK: - Private methods

    private func setupView() {
        backgroundColor = background
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        layer.shadowOffset = CGSize(width: 4, height: 1)
        layer.shadowRadius = 2.5
        layer.masksToBounds = false
    }

    private func setupSeparatorView() {
        separatorView.backgroundColor = separator
    }

    private func updateSelectedItem() {
        itemViews.enumerated().forEach { (itemView) in
            itemView.element.isSelected = itemView.offset == selectedItemIndex
        }
    }
}
