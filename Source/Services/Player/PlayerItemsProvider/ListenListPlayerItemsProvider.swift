//
//  ListenListPlayerItemsProvider.swift
//  Scout
//
//

import Foundation
import RxSwift
import RxCocoa

class ListenListPlayerItemsProvider {

    public let items: [PlayerItem]

    private let selectedItemIdBehaviorRelay: BehaviorRelay<PlayerItemIdentifier?>

    init(
        listenListRepo: ListenListRepo,
        selectedItemId: PlayerItemIdentifier?
        ) {

        items = listenListRepo.listenListItems.map { $0.playerItem }
        selectedItemIdBehaviorRelay = BehaviorRelay(value: selectedItemId)
    }
}

extension ListenListPlayerItemsProvider: PlayerItemsProvider {

    var selectedItemId: PlayerItemIdentifier? {
        return selectedItemIdBehaviorRelay.value
    }

    func item(for id: PlayerItemIdentifier) -> PlayerItem? {
        return items.first { $0.id == selectedItemId }
    }

    func selectItem(with id: PlayerItemIdentifier?) {
        selectedItemIdBehaviorRelay.accept(id)
    }

    func observeSelectedItemIdentifier() -> Observable<PlayerItemIdentifier?> {
        return selectedItemIdBehaviorRelay.asObservable()
    }
}

private extension ListenListItem {
    var playerItem: PlayerItem {
        return PlayerItem(
            id: id,
            imageUrl: imageUrl,
            type: type.playerItemType
        )
    }
}

private extension ListenListItem.ItemType {
    var playerItemType: PlayerItem.ItemType {
        switch self {

        case .article(let url):
            return .article(url)
        case .episode(let url):
            return .episode(url)
        }
    }
}
