//
//  TabBarView.swift
//  Scout
//
//

import UIKit

class TabBarView: UIView {

    private let background: UIColor = UIColor("F9F9FA")!.withAlphaComponent(0.95)

    // MARK: - Private properties

    @IBOutlet private weak var stackView: UIStackView!

    // MARK: - Public properties

    // MARK: - Public methods

    public func setItems(_ items: [TabBarItemView.Model], selectedIndex: Int = 0) {
        let itemViews = items.map { (model) -> TabBarItemView in
            let view = TabBarItemView()
            view.setup(with: model)
            return view
        }

        
    }

    // MARK: - Private methods

    private func setupView() {
        backgroundColor = background
    }
}
