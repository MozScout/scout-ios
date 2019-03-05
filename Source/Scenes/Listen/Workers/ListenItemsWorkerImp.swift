//
//  ListenItemsWorkerImp.swift
//  Scout
//
//

import Foundation

extension Listen {

    class ItemsWorkerImp {

        let listenListApi: ListenListApi

        init(listenApi: ListenListApi) {
            self.listenListApi = listenApi
        }
    }
}

extension Listen.ItemsWorkerImp: Listen.ItemsWorker {

    func removeItem(
        with itemId: Listen.Identifier,
        itemType: Listen.Model.Item.ItemType,
        completion: @escaping (Listen.ItemsWorkerRemoveItemResult) -> Void
        ) {

        let postModel = DeleteListenListItemPostModel(
            id: itemId,
            type: itemType.type
        )
        listenListApi.deleteListenListItem(with: postModel) { (result) in
            switch result {
            case .success:
                completion(.success)
            case .failure:
                completion(.failure)
            }
        }
    }

    func fetchItems(completion: @escaping (Listen.ItemsWorkerFetchItemsResult) -> Void) {
        listenListApi.requestListenList { (result) in
            switch result {
            case .success(let items):
                let items = items.map { $0.item }
                completion(.success(items))
            case .failure:
                completion(.failure)
            }
        }
    }
}

private extension Listen.Model.Item.ItemType {
    var type: DeleteListenListItemPostModel.ItemType {
        switch self {
        case .article: return .article
        case .episode: return .episode
        }
    }
}

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
