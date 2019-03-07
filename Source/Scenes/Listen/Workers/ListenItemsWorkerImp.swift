//
//  ListenItemsWorkerImp.swift
//  Scout
//
//

import Foundation
import RxSwift

extension Listen {

    class ItemsWorkerImp {

//        let listenListApi: ListenListApi

//        init(listenApi: ListenListApi) {
//            self.listenListApi = listenApi
//        }

        private let listenListRepo: ListenListRepo

        init(listenListRepo: ListenListRepo) {

            self.listenListRepo = listenListRepo
        }

        private func map(items: [ListenListItem]) -> [Listen.Model.Item] {
            return items.map({ (item) -> Listen.Model.Item in
                return item.item
            })
        }
    }
}

extension Listen.ItemsWorkerImp: Listen.ItemsWorker {

    var items: [Listen.Model.Item] {
        return map(items: listenListRepo.listenListItems)
    }

    var loadingStatus: Listen.Model.LoadingStatus {
        return listenListRepo.loadingStatus.loadingStatus
    }

    func fetchItems() {
        listenListRepo.reloadListenList()
    }

    func removeItem(with itemId: Listen.Identifier) {
        listenListRepo.removeItem(with: itemId)
    }

    func observeItems() -> Observable<[Listen.Model.Item]> {
        return listenListRepo.observeListenListItems().map({ [weak self] (items) -> [Listen.Model.Item] in
            return self?.map(items: items) ?? []
        })
    }

    func observeLoadingStatus() -> Observable<Listen.Model.LoadingStatus> {
        return listenListRepo.observeLoadingStatus().map({ (loadingStatus) -> Listen.Model.LoadingStatus in
            return loadingStatus.loadingStatus
        })
    }

//    func removeItem(
//        with itemId: Listen.Identifier,
//        itemType: Listen.Model.Item.ItemType,
//        completion: @escaping (Listen.ItemsWorkerRemoveItemResult) -> Void
//        ) {
//
//        let postModel = DeleteListenListItemPostModel(
//            id: itemId,
//            type: itemType.type
//        )
//        listenListApi.deleteListenListItem(with: postModel) { (result) in
//            switch result {
//            case .success:
//                completion(.success)
//            case .failure:
//                completion(.failure)
//            }
//        }
//    }
//
//    func fetchItems(completion: @escaping (Listen.ItemsWorkerFetchItemsResult) -> Void) {
//        listenListApi.requestListenList { (result) in
//            switch result {
//            case .success(let items):
//                let items = items.map { $0.item }
//                completion(.success(items))
//            case .failure:
//                completion(.failure)
//            }
//        }
//    }
}

//private extension Listen.Model.Item.ItemType {
//    var type: DeleteListenListItemPostModel.ItemType {
//        switch self {
//        case .article: return .article
//        case .episode: return .episode
//        }
//    }
//}

private extension ListenListItem.ItemType {
    var type: Listen.Model.Item.ItemType {
        switch self {
        case .article(let url): return .article(url: url)
        case .episode(let url): return .episode(url: url)
        }
    }
}

private extension ListenListItem {
    var item: Listen.Model.Item {
        return Listen.Model.Item(
            itemId: id,
            imageUrl: imageUrl,
            iconUrl: logoUrl,
            publisher: publisher,
            title: title,
            duration: duration,
            type: type.type
        )
    }
}

private extension ListenListRepo.LoadingStatus {
    var loadingStatus: Listen.Model.LoadingStatus {
        switch self {

        case .idle:
            return .idle

        case .loading:
            return .loading
        }
    }
}
