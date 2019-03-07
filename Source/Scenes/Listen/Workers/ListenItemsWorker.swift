//
//  ListenItemsWorker.swift
//  Scout
//
//

import Foundation
import RxSwift

protocol ListenItemsWorker {

    var items: [Listen.Model.Item] { get }
    var loadingStatus: Listen.Model.LoadingStatus { get }

    func fetchItems()
    func removeItem(with itemId: Listen.Identifier)

    func observeItems() -> Observable<[Listen.Model.Item]>
    func observeLoadingStatus() -> Observable<Listen.Model.LoadingStatus>

//    func fetchItems(completion: @escaping (Listen.ItemsWorkerFetchItemsResult) -> Void)
//    func removeItem(
//        with itemId: Listen.Identifier,
//        itemType: Listen.Model.Item.ItemType,
//        completion:  @escaping (Listen.ItemsWorkerRemoveItemResult) -> Void
//    )
}

extension Listen {

    typealias ItemsWorker = ListenItemsWorker

//    enum ItemsWorkerFetchItemsResult {
//        case success([Model.Item])
//        case failure
//    }
//
//    enum ItemsWorkerRemoveItemResult {
//        case success
//        case failure
//    }
}
