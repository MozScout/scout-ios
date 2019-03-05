//
//  ListenItemsWorker.swift
//  Scout
//
//

import Foundation

protocol ListenItemsWorker {

    func fetchItems(completion: @escaping (Listen.ItemsWorkerFetchItemsResult) -> Void)
    func removeItem(
        with itemId: Listen.Identifier,
        itemType: Listen.Model.Item.ItemType,
        completion:  @escaping (Listen.ItemsWorkerRemoveItemResult) -> Void
    )
}

extension Listen {

    typealias ItemsWorker = ListenItemsWorker

    enum ItemsWorkerFetchItemsResult {
        case success([Model.Item])
        case failure
    }

    enum ItemsWorkerRemoveItemResult {
        case success
        case failure
    }
}
