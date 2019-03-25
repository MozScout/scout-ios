//
//  SubscriptionsItemCell.swift
//  Scout
//
//

import UIKit

enum SubscriptionsItemCell {

    struct ViewModel: CellViewModel {

        let iconUrl: URL
        let date: String
        let title: String

        func setup(cell: SubscriptionsItemCell.View) {

            cell.iconUrl = iconUrl
            cell.date = date
            cell.title = title
        }
    }

    class View: UICollectionViewCell {

        // MARK: - Private properties

        private let iconView: UIImageView = UIImageView()
        private let dateLabel: UILabel = UILabel()
        private let titleLabel: UILabel = UILabel()

        // MARK: - Public properties

        public var iconUrl: URL? {
            didSet {
                iconView.kf.setImage(
                    with: iconUrl,
                    placeholder: UIImage.fxPlaceholder,
                    options: [.backgroundDecode]
                )
            }
        }

        public var date: String? {
            get { return dateLabel.text }
            set { dateLabel.text = newValue }
        }

        public var title: String? {
            get { return titleLabel.text }
            set { titleLabel.text = newValue }
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

        // MARK: - Private methods

        private func commonInit() {
            setupView()
            setupIconView()
            setupDateLabel()
            setupTitleLabel()

            setupLayout()
        }

        private func setupView() {
            backgroundColor = UIColor.clear
        }

        private func setupIconView() {
            iconView.contentMode = .scaleAspectFill
            iconView.clipsToBounds = true
        }

        private func setupDateLabel() {
            dateLabel.font = UIFont.sfProText(.regular, ofSize: 14)
            dateLabel.textColor = UIColor.fxDoveGray
            dateLabel.numberOfLines = 1
            dateLabel.textAlignment = .center
        }

        private func setupTitleLabel() {
            titleLabel.font = UIFont.sfProText(.regular, ofSize: 14)
            titleLabel.textColor = UIColor.fxBlack
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
        }

        private func setupLayout() {
            contentView.addSubview(iconView)
            contentView.addSubview(dateLabel)
            contentView.addSubview(titleLabel)

            iconView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview()
                make.height.width.equalTo(150)
            }

            dateLabel.setContentCompressionResistancePriority(
                .required,
                for: .horizontal
            )
            dateLabel.setContentCompressionResistancePriority(
                .required,
                for: .vertical
            )
            dateLabel.setContentHuggingPriority(
                .required,
                for: .vertical
            )
            dateLabel.snp.makeConstraints { (make) in
                make.top.equalTo(iconView.snp.bottom).offset(4)
                make.left.right.equalToSuperview().inset(8)
                make.centerX.equalToSuperview()
            }

            titleLabel.setContentCompressionResistancePriority(
                .required,
                for: .horizontal
            )
            titleLabel.setContentCompressionResistancePriority(
                .required,
                for: .vertical
            )
            titleLabel.setContentHuggingPriority(
                .required,
                for: .horizontal
            )
            titleLabel.setContentHuggingPriority(
                .required,
                for: .vertical
            )
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(dateLabel.snp.bottom).offset(2)
                make.left.right.equalToSuperview().inset(8)
                make.centerX.equalToSuperview()
                make.bottom.lessThanOrEqualToSuperview()
            }
        }
    }
}
