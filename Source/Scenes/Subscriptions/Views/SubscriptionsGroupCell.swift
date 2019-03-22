//
//  SubscriptionsGroupCell.swift
//  Scout
//
//

import UIKit

enum SubscriptionsGroupCell {
    struct ViewModel: CellViewModel {

        let items: [SubscriptionsItemCell.ViewModel]

        func setup(cell: SubscriptionsGroupCell.View) {
            cell.items = items
        }
    }

    class View: UICollectionViewCell {

        // MARK: - Private properties

        private let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        private lazy var collectionView: UICollectionView = {
            return UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        }()

        // MARK: - Public properties

        public var items: [SubscriptionsItemCell.ViewModel] = [] {
            didSet {
                collectionView.reloadData()
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
            setupCollectionView()

            setupLayout()
        }

        private func setupView() {
            backgroundColor = UIColor.clear
        }

        private func setupCollectionView() {
            setupCollectionViewLayout()

            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.alwaysBounceVertical = false
            collectionView.alwaysBounceHorizontal = true
            collectionView.backgroundColor = UIColor.white
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false

            collectionView.register(classes: [SubscriptionsItemCell.ViewModel.self])

            collectionView.contentInset = UIEdgeInsets(
                top: 0,
                left: 10,
                bottom: 0,
                right: 10
            )
        }

        private func setupCollectionViewLayout() {
            collectionViewLayout.scrollDirection = .horizontal
            collectionViewLayout.estimatedItemSize = CGSize(width: 150, height: 220)
            collectionViewLayout.minimumLineSpacing = 20
            collectionViewLayout.sectionInset = .zero
        }

        private func setupLayout() {
            contentView.addSubview(collectionView)

            collectionView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
}

extension SubscriptionsGroupCell.View: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
        ) {

        // TODO: - Implement
    }
}

extension SubscriptionsGroupCell.View: UICollectionViewDataSource {

    func numberOfSections(
        in collectionView: UICollectionView
        ) -> Int {

        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {

        return items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {

        return collectionView.dequeueReusableCell(
            with: items[indexPath.item],
            for: indexPath
        )
    }
}
