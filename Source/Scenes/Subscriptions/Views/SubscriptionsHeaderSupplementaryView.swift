//
//  SubscriptionsHeaderSupplementaryView.swift
//  Scout
//
//

import UIKit

enum SubscriptionsHeaderSupplementaryView {

    struct ViewModel: SupplementaryViewModel {

        static var kind: String {
            return UICollectionView.elementKindSectionHeader
        }

        let title: String

        func setup(view: SubscriptionsHeaderSupplementaryView.View) {

            view.title = title
        }
    }

    class View: UICollectionReusableView {

        // MARK: - Private properties

        private let titleLabel: UILabel = UILabel()
        private let moreButton: UIButton = UIButton()

        // MARK: - Public properties

        public var title: String? {
            get { return titleLabel.text }
            set { titleLabel.text = newValue }
        }

        public var onMoreButtonTap: (() -> Void)?

        // MARK: -

        override init(frame: CGRect) {
            super.init(frame: frame)

            commonInit()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)

            commonInit()
        }

        // MARK: - Private methods

        private func commonInit() {
            setupView()
            setupTitleLabel()
            setupMoreButton()

            setupLayout()
        }

        private func setupView() {
            backgroundColor = UIColor.clear
        }

        private func setupTitleLabel() {
            titleLabel.textColor = UIColor.fxBlack
            titleLabel.font = UIFont.sfProText(.bold, ofSize: 12)
            titleLabel.numberOfLines = 1
            titleLabel.textAlignment = .left
        }

        private func setupMoreButton() {
            moreButton.setImage(UIImage.fxMore, for: .normal)
            moreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
            moreButton.tintColor = UIColor.fxBlack
        }

        @objc private func moreButtonAction() {
            onMoreButtonTap?()
        }

        private func setupLayout() {
            addSubview(titleLabel)
            addSubview(moreButton)

            titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(10)
                make.top.greaterThanOrEqualToSuperview().inset(3)
                make.bottom.lessThanOrEqualToSuperview().inset(1)
                make.centerY.equalToSuperview().inset(1)
            }

            moreButton.snp.makeConstraints { (make) in
                make.right.equalToSuperview().inset(10)
                make.size.equalTo(24)
                make.top.bottom.equalToSuperview().inset(3)
                make.left.equalTo(self.titleLabel.snp.right).offset(8)
            }
        }

        // MARK: - Public methods
    }
}
