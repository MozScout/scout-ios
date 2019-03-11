//
//  ListenItemsWorkerImp.swift
//  Scout
//
//

import Foundation
import RxSwift

extension Listen {

    class ItemsWorkerImp {

        private let listenListRepo: ListenListRepo
        private let playerItemsProvider: PlayerItemsProviderFacade

        init(
            listenListRepo: ListenListRepo,
            playerItemsProvider: PlayerItemsProviderFacade
            ) {

            self.listenListRepo = listenListRepo
            self.playerItemsProvider = playerItemsProvider
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

    func setItemToPlayer(_ itemId: Listen.Identifier) {
        let listenLisetProvider = ListenListPlayerItemsProvider(
            listenListRepo: listenListRepo,
            selectedItemId: nil
        )
        playerItemsProvider.setSelectedItem(
            identifier: itemId,
            in: listenLisetProvider
        )
    }
}

private extension ListenListItem.ItemType {
    var type: Listen.Model.Item.ItemType {
        switch self {
        case .article: return .article
        case .episode: return .episode
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
