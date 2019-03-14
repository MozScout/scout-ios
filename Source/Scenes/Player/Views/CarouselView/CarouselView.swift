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
        return cellRegularSize + 30
    }

    private var cellRegularSize: CGFloat {
        return bounds.height - 30
    }

    private let interitemSpacing: CGFloat = 11

    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var collectionViewLayout: CarouselLayout = {
        return CarouselLayout(
            standardItemSize: cellRegularSize,
            focusedItemSize: cellLargeSize,
            interitemInset: interitemSpacing,
            dataSource: self
        )
    }()

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
        collectionViewLayout.invalidateLayout()
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

        collectionView.collectionViewLayout = collectionViewLayout

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

        var contentOffset = collectionViewLayout.offsetToCenterItem(at: indexPath)
        contentOffset.x -= collectionView.contentInset.left

        collectionView.setContentOffset(contentOffset, animated: animated)
    }

    private func centerMostItemIndexPath() -> IndexPath? {
        let visibleCells = collectionView.visibleCells

        let viewConvertTo: UIView = self
        let viewCenter = viewConvertTo.center
        let distanceToCenterFrom: (CGRect) -> CGFloat = { (rect) in
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

            if distanceToCenterFrom(frame) > distanceToCenterFrom(cellFrame) {
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

extension CarouselView: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
        ) {

        scrollToItem(at: indexPath, animated: true)
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

extension CarouselView: CarouselLayout.DataSource {

    func numberOfItems(in collectionView: UICollectionView) -> Int {
        return items.count
    }
}

// MARK: - CarouselLayout

private class CarouselLayout: UICollectionViewLayout {

    typealias DataSource = CarouselLayoutDataSource

    // MARK: - Private properties

    private let dataSource: DataSource

    private let standardItemSize: CGFloat
    private let focusedItemSize: CGFloat
    private let interitemInset: CGFloat

    private var layoutAttributesCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    private var contentSize: CGSize = .zero

    // MARK: -

    init(
        standardItemSize: CGFloat,
        focusedItemSize: CGFloat,
        interitemInset: CGFloat,
        dataSource: DataSource
        ) {

        self.standardItemSize = standardItemSize
        self.focusedItemSize = focusedItemSize
        self.interitemInset = interitemInset
        self.dataSource = dataSource

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        contentSize = calculateContentSize(
            for: dataSource.numberOfItems(in: collectionView),
            withInteritemInset: interitemInset,
            focusedItemSize: focusedItemSize,
            standardItemSize: standardItemSize
        )
    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }

        var layoutAttributes: [UICollectionViewLayoutAttributes] = []

        var visibleIndexPaths: [IndexPath] = Array(layoutAttributesCache
            .filter { (tuple) -> Bool in
                return rect.intersects(tuple.value.frame)
            }
            .keys
            )
            .sorted { (left, right) -> Bool in
                return left.item > right.item
        }

        if visibleIndexPaths.isEmpty {
            visibleIndexPaths = (0..<dataSource.numberOfItems(in: collectionView)).map { (number) -> IndexPath in
                return IndexPath(item: number, section: 0)
            }
        }

        for indexPath in visibleIndexPaths {
            if let attributes = layoutAttributesForItem(at: indexPath) {
                layoutAttributes.append(attributes)
            }
        }

        return layoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }

        let collectionViewVisibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let sizeDifference: CGFloat = focusedItemSize - standardItemSize

        let origin: CGPoint

        if let previousIndexPath = self.indexPath(before: indexPath),
            let previousAttributes = self.layoutAttributesCache[previousIndexPath] {

            origin = CGPoint(x: previousAttributes.frame.maxX + interitemInset, y: sizeDifference / 2)

        } else {

            let itemsBefore = indexPath.item
            let interitemInsetsBefore = itemsBefore

            let itemsBeforeSize: CGFloat = CGFloat(itemsBefore) * standardItemSize
            let interitemInsetsBeforeSize: CGFloat = CGFloat(interitemInsetsBefore) * interitemInset

            origin = CGPoint(x: itemsBeforeSize + interitemInsetsBeforeSize, y: sizeDifference / 2)
        }

        let size = CGSize(width: standardItemSize, height: standardItemSize)
        var frame = CGRect(origin: origin, size: size)

        let collectionViewCenter = (focusedItemSize + standardItemSize) / 2
        let distanceToCenter = abs(collectionViewVisibleRect.midX - frame.midX)
        let percent = max(collectionViewCenter - distanceToCenter, 0) / collectionViewCenter

        let additionalSize = sizeDifference * percent
        let itemSize = standardItemSize + additionalSize

        frame.size = CGSize(width: itemSize, height: itemSize)
        frame.origin = CGPoint(x: frame.origin.x, y: (sizeDifference - additionalSize) / 2)

        attributes.frame = frame

        layoutAttributesCache[indexPath] = attributes
        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return collectionView?.bounds != newBounds
    }

    // MARK: - Public methods

    public func offsetToCenterItem(at indexPath: IndexPath) -> CGPoint {

        let itemsNumber = max(indexPath.item, 0)

        // Insets size

        let insetsNumber = max(itemsNumber, 0)

        let insetsSize: CGFloat = CGFloat(insetsNumber) * interitemInset

        // Items size

        let focusedItemsNumber = 0
        let focusedItemsSize: CGFloat = CGFloat(focusedItemsNumber) * focusedItemSize

        let standardItemsNumber = max(itemsNumber - focusedItemsNumber, 0)
        let standardItemsSize: CGFloat = CGFloat(standardItemsNumber) * standardItemSize

        let itemsSize: CGFloat = focusedItemsSize + standardItemsSize

        return CGPoint(x: itemsSize + insetsSize, y: 0)
    }

    // MARK: - Private methods

    private func calculateContentSize(
        for numberOfItems: Int,
        withInteritemInset interitemInset: CGFloat,
        focusedItemSize: CGFloat,
        standardItemSize: CGFloat
        ) -> CGSize {

        let itemsNumber = max(numberOfItems, 0)
        let insetsNumber = max(itemsNumber - 1, 0)

        let insetsSize: CGFloat = CGFloat(insetsNumber) * interitemInset

        let focusedItemsNumber = 1
        let focusedItemsSize: CGFloat = CGFloat(focusedItemsNumber) * focusedItemSize

        let standardItemsNumber = max(itemsNumber - focusedItemsNumber, 0)
        let standardItemsSize: CGFloat = CGFloat(standardItemsNumber) * standardItemSize

        let itemsSize: CGFloat = focusedItemsSize + standardItemsSize

        return CGSize(width: itemsSize + insetsSize, height: focusedItemSize)
    }

    private func forEachIndexPath(
        before indexPath: IndexPath,
        do block: (IndexPath) -> Void
        ) {

        for item in 0..<indexPath.item {
            block(IndexPath(item: item, section: indexPath.section))
        }
    }

    private func indexPath(before indexPath: IndexPath) -> IndexPath? {

        guard indexPath.item > 0 else { return nil }

        return IndexPath(item: indexPath.item - 1, section: indexPath.section)
    }
}

// MARK: - CarouselLayoutDataSource

private protocol CarouselLayoutDataSource {

    func numberOfItems(in collectionView: UICollectionView) -> Int
}
