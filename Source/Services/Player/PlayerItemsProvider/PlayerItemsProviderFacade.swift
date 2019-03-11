//
//  PlayerItemsProviderFacade.swift
//  Scout
//
//

import Foundation

class PlayerItemsProviderFacade {

    private var currentProvider: PlayerItemsProvider?

    func setSelectedItem(
        identifier: PlayerItemIdentifier,
        in provider: PlayerItemsProvider
        ) {

        currentProvider = provider
        selectItem(with: identifier)
    }
}

extension PlayerItemsProviderFacade: PlayerItemsProvider {
    
    var items: [PlayerItem] {
        return currentProvider?.items ?? []
    }

    var selectedItemId: PlayerItemIdentifier? {
        return currentProvider?.selectedItemId
    }

    func selectItem(with id: PlayerItemIdentifier?) {
        currentProvider?.selectItem(with: id)
    }
}
