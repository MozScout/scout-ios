//
//  CarouselView.swift
//  Scout
//
//

import UIKit

class CarouselView: UIView {

    struct Item {
        let imageUrl: URL
    }

    // MARK: - Private properties

    private var cellLargeSize: CGFloat {
        return bounds.height
    }

    private var cellRegularSize: CGFloat {
        return cellLargeSize - 30
    }

    private let interitemSpacing: CGFloat = 11

    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private var items: [CarouselViewCell.ViewModel] = []

    // MARK: - Public properties

    // MARK: -

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let collectionViewHalfWidth: CGFloat = collectionView.bounds.width / 2
        let cellHalfWidth: CGFloat = cellLargeSize / 2
        let sideInset: CGFloat = collectionViewHalfWidth - cellHalfWidth

        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: sideInset,
            bottom: 0,
            right: sideInset
        )
    }

    // MARK: - Public methods

    public func setItems(_ items: [Item]) {
        self.items = items.map({ (item) -> CarouselViewCell.ViewModel in
            return CarouselViewCell.ViewModel(imageUrl: item.imageUrl)
        })

        collectionView.reloadData()
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
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.masksToBounds = false

        collectionView.register(classes: [CarouselViewCell.ViewModel.self])

        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
    }

    private func setupLayout() {
        addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func scrollToItem(
        at indexPath: IndexPath,
        animated: Bool
        ) {

        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let cellFrame = cell.frame

        var contentOffset = CGPoint(
            x: cellFrame.minX,
            y: collectionView.contentOffset.y
        )
        contentOffset.x -= collectionView.contentInset.left

        collectionView.setContentOffset(contentOffset, animated: animated)
    }

    private func centerMostItemIndexPath() -> IndexPath? {
        let visibleCells = collectionView.visibleCells

        let viewConvertTo: UIView = self
        let viewCenter = viewConvertTo.center
        let distanceToCenter: (CGRect) -> CGFloat = { (rect) in
            return abs(viewCenter.x - rect.midX)
        }

        let visibleCellsFrames = visibleCells.map { (cell) -> CGRect in
            return cell.convert(cell.bounds, to: viewConvertTo)
        }

        var centerMostIndexPath: IndexPath?
        var centerMostFrame: CGRect?
        for (cell, cellFrame) in zip(visibleCells, visibleCellsFrames)  {
            guard let frame = centerMostFrame else {
                centerMostIndexPath = collectionView.indexPath(for: cell)
                centerMostFrame = cellFrame
                continue
            }

            if distanceToCenter(frame) > distanceToCenter(cellFrame) {
                centerMostIndexPath = collectionView.indexPath(for: cell)
                centerMostFrame = cellFrame
            }
        }

        return centerMostIndexPath
    }

    private func item(for indexPath: IndexPath) -> CarouselViewCell.ViewModel {
        return items[indexPath.item]
    }
}

// MARK: - UIScrollViewDelegate

extension CarouselView {

    func scrollViewDidEndDragging(
        _ scrollView: UIScrollView,
        willDecelerate decelerate: Bool
        ) {

        guard !decelerate else { return }
        guard let indexPath = centerMostItemIndexPath() else { return }

        scrollToItem(at: indexPath, animated: true)
    }

    func scrollViewDidEndDecelerating(
        _ scrollView: UIScrollView
        ) {

        guard let indexPath = centerMostItemIndexPath() else { return }

        scrollToItem(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension CarouselView {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
        ) {

        scrollToItem(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CarouselView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {

        guard collectionView == self.collectionView else {
            return .zero
        }
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return CGSize(width: cellRegularSize, height: cellRegularSize)
        }

        let cellRect = cell.convert(cell.bounds, to: collectionView)
        let collectionViewRect = collectionView.bounds
        let cellCenter = max(collectionViewRect.minX, min(collectionViewRect.maxX, cellRect.midX))
        let collectionViewCenter = collectionViewRect.midX

        let distanceToCenter = abs(collectionViewCenter - cellCenter)
        let percent = (collectionViewCenter - distanceToCenter) / collectionViewCenter

        let cellSizeDifference = cellLargeSize - cellRegularSize
        let cellSize = cellRegularSize + cellSizeDifference * percent

        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
        ) -> CGFloat {

        return interitemSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
        ) -> CGFloat {

        return 0
    }
}

// MARK: - UICollectionViewDataSource

extension CarouselView: UICollectionViewDataSource {
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

        return collectionView.dequeueReusableCell(with: item(for: indexPath), for: indexPath)
    }
}

//private class CarouselLayout: UICollectionViewLayout {
//
//    private let delegate: Delegate
//
//    private let standardCellSize: CGFloat
//    private let centerCellSize: CGFloat
//
//    private var attributes: [[UICollectionViewLayoutAttributes]] = []
//
//    init(
//        standardCellSize: CGFloat,
//        centerCellSize: CGFloat
//        ) {
//
//        self.standardCellSize = standardCellSize
//        self.centerCellSize = centerCellSize
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func prepare() {
//        var frame: CGRect = CGRect.zero
//        var y: CGFloat = 0
//
//        for section in 0..<delegate.numberOfSectios(self) {
//            for item in 0..<delegate.numberOfItems(self, in: section) {
//                let indexPath = IndexPath(item: item, section: section)
//                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//
//
//            }
//        }
//
//        for item in 0 ..< numberOfItems {
//
//            let indexPath = IndexPath(item: item, section: 0)
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//
//            // 2
//            attributes.zIndex = item
//            var height = standardCellSize
//
//            // 3
//            if indexPath.item == featuredItemIndex {
//                // 4
//                let yOffset = standardCellSize * nextItemPercentageOffset
//                y = collectionView!.contentOffset.y - yOffset
//                height = centerCellSize
//            } else if indexPath.item == (featuredItemIndex + 1)
//                && indexPath.item != numberOfItems {
//                // 5
//                let maxY = y + standardHeight
//                height = standardHeight + max(
//                    (featuredHeight - standardHeight) * nextItemPercentageOffset, 0
//                )
//                y = maxY - height
//            }
//
//            // 6
//            frame = CGRect(x: 0, y: y, width: width, height: height)
//            attributes.frame = frame
//            cache.append(attributes)
//            y = frame.maxY
//        }
//    }
//}
//
//extension CarouselLayout {
//    protocol Delegate {
//
//        func numberOfSectios(_ carouselLayout: CarouselLayout) -> Int
//        func numberOfItems(_ carouselLayout: CarouselLayout, in section: Int) -> Int
//    }
//}
