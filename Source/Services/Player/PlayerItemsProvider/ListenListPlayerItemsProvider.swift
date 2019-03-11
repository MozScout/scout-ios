//
//  ListenListPlayerItemsProvider.swift
//  Scout
//
//

import Foundation

class ListenListPlayerItemsProvider {

    public let items: [PlayerItem]
    private(set) var selectedItemId: PlayerItemIdentifier?

    init(
        listenListRepo: ListenListRepo,
        selectedItemId: PlayerItemIdentifier?
        ) {

        items = listenListRepo.listenListItems.map { $0.playerItem }
        self.selectedItemId = selectedItemId
    }
}

extension ListenListPlayerItemsProvider: PlayerItemsProvider {

    func selectItem(with id: PlayerItemIdentifier?) {
        selectedItemId = id
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
