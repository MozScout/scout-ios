//
//  CategorySectionHeaderView.swift
//  Scout
//
//

import UIKit

class CategorySectionHeaderView: UICollectionReusableView {

    struct ViewModel {
        let title: String
    }

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUi()
    }

    func configure(_ state: ViewModel) {
        titleLabel.text = state.title
    }
}

// MARK: - Private

private extension CategorySectionHeaderView {

    func setupUi() {
        titleLabel.font = UIFont.sfProText(.semibold, ofSize: 14)
        titleLabel.textColor = UIColor.black
    }
}
