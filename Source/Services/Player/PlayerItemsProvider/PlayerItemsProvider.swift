//
//  PlayerItemsProvider.swift
//  Scout
//
//

import Foundation
import RxSwift

typealias PlayerItemIdentifier = String

struct PlayerItem {
    enum ItemType {
        case article(URL)
        case episode(URL)
    }

    let id: PlayerItemIdentifier
    let imageUrl: URL
    let type: ItemType
}

protocol PlayerItemsProvider {

    var items: [PlayerItem] { get }

    var selectedItemId: PlayerItemIdentifier? { get }

    func selectItem(with id: PlayerItemIdentifier?)
}
