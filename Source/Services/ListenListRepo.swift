//
//  ListenListRepo.swift
//  Scout
//
//

import Foundation
import RxSwift
import RxCocoa

class ListenListRepo {

    typealias ItemIdentifier = String

    enum LoadingStatus {
        case loading
        case idle
    }

    // MARK: - Private properties

    private let listenListItemsBehaviorRelay: BehaviorRelay<[ListenListItem]> = BehaviorRelay(value: [])
    private let loadingStatusBehaviorRelay: BehaviorRelay<LoadingStatus> = BehaviorRelay(value: .idle)

    private let listenListApi: ListenListApi

    // MARK: - Public properties

    public var listenListItems: [ListenListItem] {
        return listenListItemsBehaviorRelay.value
    }

    public var loadingStatus: LoadingStatus {
        return loadingStatusBehaviorRelay.value
    }

    // MARK: -

    init(
        listenListApi: ListenListApi
        ) {

        self.listenListApi = listenListApi
    }

    // MARK: - Private methods

    private func listenListItemIndex(for id: ItemIdentifier) -> Int? {
        return listenListItems.firstIndex(where: { (item) -> Bool in
            return item.id == id
        })
    }

    // MARK: - Public methods

    public func observeListenListItems() -> Observable<[ListenListItem]> {
        return listenListItemsBehaviorRelay.asObservable()
    }

    public func observeLoadingStatus() -> Observable<LoadingStatus> {
        return loadingStatusBehaviorRelay.asObservable()
    }

    public func reloadListenList() {

        loadingStatusBehaviorRelay.accept(.loading)
        listenListApi.requestListenList { [weak self] (result) in
            switch result {

            case .success(let items):
                self?.listenListItemsBehaviorRelay.accept(items)

            case .failure:
                break
            }

            self?.loadingStatusBehaviorRelay.accept(.idle)
        }
    }

    public func removeItem(with id: ItemIdentifier) {

        guard let index = listenListItemIndex(for: id) else {
            return
        }

        let item = listenListItems[index]
        let postModel = DeleteListenListItemPostModel(
            id: item.id,
            type: item.type.type
        )
        listenListApi.deleteListenListItem(with: postModel) { (result) in
            switch result {
            case .success:
                break
            case .failure:
                break
            }
        }

        var newList = listenListItems
        newList.remove(at: index)
        listenListItemsBehaviorRelay.accept(newList)
    }
}

private extension ListenListItem.ItemType {
    var type: DeleteListenListItemPostModel.ItemType {
        switch self {
        case .article: return .article
        case .episode: return .episode
        }
    }
}
