//
//  CarouselView.swift
//  Scout
//
//

import UIKit

// MARK: - CarouselView.Item -

extension CarouselView {
    struct Item {
        typealias Identifier = Player.Identifier

        let imageUrl: URL
        let id: Identifier
    }
}

// MARK: - CarouselView -

class CarouselView: UIView {

    // MARK: - Private properties

    private var cellLargeSize: CGFloat {
        return collectionView.bounds.height
    }

    private var cellRegularSize: CGFloat {
        return cellLargeSize - 30
    }

    private let interitemSpacing: CGFloat = 11

    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var collectionViewLayout: CarouselLayout = {
        return CarouselLayout(
            dataSource: self,
            delegate: self
        )
    }()

    private var items: [CarouselViewCell.ViewModel] = []

    // MARK: - Public properties

    public var scrollViewDidScroll: (() -> Void)?
    public var didSelectItem: ((_ with: Item.Identifier) -> Void)?

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

    public func setItems(
        _ items: [Item],
        selectedIndexPath indexPath: IndexPath?
        ) {

        self.items = items.map({ (item) -> CarouselViewCell.ViewModel in
            return CarouselViewCell.ViewModel.init(imageUrl: item.imageUrl, id: item.id)
        })

        collectionView.reloadData()
        collectionViewLayout.invalidateLayout()

        if let indexPath = indexPath {
            scrollToItem(at: indexPath, animated: false)
        }
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
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.alwaysBounceVertical = false
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.masksToBounds = false

        collectionView.collectionViewLayout = collectionViewLayout

        collectionView.register(classes: [CarouselViewCell.ViewModel.self])
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
        let viewConvertToBounds = viewConvertTo.bounds
        let distanceToCenterFrom: (CGRect) -> CGFloat = { (rect) in
            return abs(viewConvertToBounds.midX - rect.midX)
        }

        let visibleCellsFrames = visibleCells.map { (cell) -> CGRect in
            return cell.convert(cell.bounds, to: viewConvertTo)
        }

        var centerMostIndexPath: IndexPath?
        var centerMostFrame: CGRect?
        for (cell, cellFrame) in zip(visibleCells, visibleCellsFrames)  {
            if let frame = centerMostFrame,
                distanceToCenterFrom(frame) < distanceToCenterFrom(cellFrame) {
                continue
            }

            centerMostIndexPath = collectionView.indexPath(for: cell)
            centerMostFrame = cellFrame
        }

        return centerMostIndexPath
    }

    private func item(for indexPath: IndexPath) -> CarouselViewCell.ViewModel {
        return items[indexPath.item]
    }
}

// MARK: - UIScrollViewDelegate

extension CarouselView {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScroll?()
    }

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
        guard !scrollView.isDragging,
            !scrollView.isTracking
            else {
                return
        }
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
        didSelectItem?(item(for: indexPath).id)
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

        return collectionView.dequeueReusableCell(
            with: item(for: indexPath),
            for: indexPath
        )
    }
}

// MARK: - CarouselLayout.DataSource

extension CarouselView: CarouselLayout.DataSource {

    func numberOfItems(
        in collectionView: UICollectionView
        ) -> Int {

        return items.count
    }
}

extension CarouselView: CarouselLayout.Delegate {
    var focusedItemSize: CGSize {
        return CGSize(width: cellLargeSize, height: cellLargeSize)
    }

    var regularItemSize: CGSize {
        return CGSize(width: cellRegularSize, height: cellRegularSize)
    }

    var interitemInset: CGFloat {
        return interitemSpacing
    }
}

// MARK: - CarouselLayout -

private class CarouselLayout: UICollectionViewLayout {

    // MARK: - Private properties

    private let dataSource: DataSource
    private let delegate: Delegate

    private var layoutAttributesCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    private var contentSize: CGSize = .zero
    private var currentNumberOfItems: Int = -1

    // MARK: -

    init(
        dataSource: DataSource,
        delegate: Delegate
        ) {

        self.dataSource = dataSource
        self.delegate = delegate

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        recalculateContentSizeIfNeeded()
        recacheLayoutAttributesForItemsIfNeeded()

        guard let collectionView = collectionView else { return }
        currentNumberOfItems = dataSource.numberOfItems(in: collectionView)
    }

    private func recalculateContentSizeIfNeeded() {
        guard let collectionView = collectionView else { return }
        guard currentNumberOfItems != dataSource.numberOfItems(in: collectionView) else { return }

        contentSize = calculateContentSize(
            for: dataSource.numberOfItems(in: collectionView),
            withInteritemInset: delegate.interitemInset,
            focusedItemSize: delegate.focusedItemSize,
            standardItemSize: delegate.regularItemSize
        )
    }

    private func recacheLayoutAttributesForItemsIfNeeded() {
        guard let collectionView = collectionView else { return }
        guard currentNumberOfItems != dataSource.numberOfItems(in: collectionView) else { return }

        layoutAttributesCache = [:]
        initiallyCacheLayoutAttributesForItems()
    }

    private func initiallyCacheLayoutAttributesForItems() {
        guard let collectionView = collectionView else { return }

        let visibleIndexPaths = (0..<dataSource.numberOfItems(in: collectionView)).map { (number) -> IndexPath in
            return IndexPath(item: number, section: 0)
        }

        for indexPath in visibleIndexPaths {
            _ = layoutAttributesForItem(at: indexPath)
        }
    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return Array(layoutAttributesCache
            .filter { (tuple) -> Bool in
                return rect.intersects(tuple.value.frame)
            }
            .keys)
            .sorted(by: > )
            .compactMap { self.layoutAttributesForItem(at: $0) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }

        let collectionViewVisibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        let sizeDifference: CGFloat = delegate.focusedItemSize.height - delegate.regularItemSize.height

        let size = delegate.regularItemSize
        let originX: CGFloat = {
            if let previousIndexPath = self.indexPath(before: indexPath),
                let previousAttributes = layoutAttributesCache[previousIndexPath] {

                return previousAttributes.frame.maxX + delegate.interitemInset
            } else {

                let estimatedItemFrame = estimatedFrameForItem(
                    at: indexPath,
                    with: size
                )
                return estimatedItemFrame.minX
            }
        }()
        let origin = CGPoint(x: originX,  y: sizeDifference / 2)
        var frame = CGRect(origin: origin, size: size)

        let focusStartPoint: CGFloat = collectionViewVisibleRect.midX - delegate.focusedItemSize.width / 2 - delegate.interitemInset - delegate.regularItemSize.width
        let focusPoint: CGFloat = collectionViewVisibleRect.midX - delegate.focusedItemSize.width / 2
        let focusEndPoint: CGFloat = collectionViewVisibleRect.midX + delegate.focusedItemSize.width / 2 + delegate.interitemInset

        let distanceToCenter: CGFloat = abs(focusPoint - frame.minX)
        let centerSize: CGFloat = {
            if frame.minX > focusEndPoint {
                return focusEndPoint - focusPoint
            } else if frame.minX > focusPoint {
                return focusEndPoint - focusPoint
            } else if frame.minX > focusStartPoint {
                return focusPoint - focusStartPoint
            } else {
                return focusPoint - focusStartPoint
            }
        }()

        let percent = max(centerSize - distanceToCenter, 0) / centerSize

        let additionalSize = sizeDifference * percent
        let itemSize = delegate.regularItemSize.height + additionalSize

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

        let estimatedItemFrame = estimatedFrameForItem(
            at: indexPath,
            with: delegate.focusedItemSize
        )
        return CGPoint(x: estimatedItemFrame.minX, y: 0)
    }

    // MARK: - Private methods

    /// Calculates estimated frame for item at indexPath.
    ///
    /// - Parameters:
    ///   - indexPath: indexPath of the item
    ///   - size: size of the item
    /// - Returns: estimated frame for item all predecessors of which are standard sized items
    private func estimatedFrameForItem(
        at indexPath: IndexPath,
        with size: CGSize
        ) -> CGRect {

        let itemsBeforeNumber = indexPath.item
        let interitemInsetsBeforeNumber = itemsBeforeNumber

        let itemsBeforeSize: CGFloat = CGFloat(itemsBeforeNumber) * delegate.regularItemSize.width
        let interitemInsetsBeforeSize: CGFloat = CGFloat(interitemInsetsBeforeNumber) * delegate.interitemInset

        let origin: CGPoint = CGPoint(
            x: itemsBeforeSize + interitemInsetsBeforeSize,
            y: (delegate.focusedItemSize.height - size.height) / 2
        )

        return CGRect(origin: origin, size: size)
    }

    private func calculateContentSize(
        for numberOfItems: Int,
        withInteritemInset interitemInset: CGFloat,
        focusedItemSize: CGSize,
        standardItemSize: CGSize
        ) -> CGSize {

        let indexPath = IndexPath(item: numberOfItems - 1, section: 0)
        let estimatedFrame = estimatedFrameForItem(at: indexPath, with: focusedItemSize)

        return CGSize(width: estimatedFrame.maxX, height: focusedItemSize.height)
    }

    private func indexPath(before indexPath: IndexPath) -> IndexPath? {

        guard indexPath.item > 0 else { return nil }
        return IndexPath(item: indexPath.item - 1, section: indexPath.section)
    }
}

// MARK: - CarouselLayoutDataSource -

private protocol CarouselLayoutDataSource {

    func numberOfItems(in collectionView: UICollectionView) -> Int
}

private protocol CarouselLayoutDelegate {

    var focusedItemSize: CGSize { get }
    var regularItemSize: CGSize { get }
    var interitemInset: CGFloat { get }
}

private extension CarouselLayout {

    typealias DataSource = CarouselLayoutDataSource
    typealias Delegate = CarouselLayoutDelegate
}
