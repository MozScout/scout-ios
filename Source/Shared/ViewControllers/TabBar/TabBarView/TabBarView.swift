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

    // MARK: - Private properties

    @IBOutlet private weak var stackView: UIStackView!

    private var itemViews: [TabBarItemView] = []

    // MARK: - Public properties

    public var selectedItemIndex: Int? = nil {
        didSet {
            updateSelectedItem()
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: <#T##CGFloat#>, height: 61)
    }

    // MARK: - Public methods

    public func setItems(_ items: [Item], selectedIndex: Int = 0) {
        itemViews = items.map { (item) -> TabBarItemView in
            let model = TabBarItemView.Model(
                title: item.title,
                icon: item.icon
            )

            let view = TabBarItemView()
            view.setup(with: model)
            return view
        }
        stackView.setArrangedSubviews(itemViews)

        for itemView in itemViews.enumerated() {
            itemView.element.onSelected = { [weak self] (_) in
                let index = itemView.offset
                self?.selectedItemIndex = index
                items[index].onSelect()
            }
        }

        if 0..<itemViews.count ~= selectedIndex {
            selectedItemIndex = selectedIndex
        }
    }

    // MARK: - Private methods

    private func setupView() {
        backgroundColor = background
    }

    private func updateSelectedItem() {
        itemViews.enumerated().forEach { (itemView) in
            itemView.element.isSelected = itemView.offset == selectedItemIndex
        }
    }
}
