//
//  CarouselViewCell.swift
//  Scout
//
//

import UIKit

enum CarouselViewCell {
    struct ViewModel: CellViewModel {

        let imageUrl: URL

        func setup(cell: CarouselViewCell.View) {
            cell.imageUrl = imageUrl
        }
    }

    class View: UICollectionViewCell {

        // MARK: - Private properties

        private let imageView: UIImageView = UIImageView()

        private let cornerRadius: CGFloat = 6

        // MARK: - Public properties

        public var imageUrl: URL? {
            didSet {
                imageView.kf.setImage(with: imageUrl, placeholder: UIImage.fxPlaceholder, options: [.backgroundDecode])
            }
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
            setupImageView()

            setupLayout()
        }

        private func setupView() {
            backgroundColor = UIColor.clear
            layer.shadowRadius = 30 / 2
            layer.shadowOpacity = 0.2
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 10)
        }

        private func setupImageView() {
            imageView.layer.cornerRadius = cornerRadius
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
        }

        private func setupLayout() {
            contentView.addSubview(imageView)

            imageView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
}
