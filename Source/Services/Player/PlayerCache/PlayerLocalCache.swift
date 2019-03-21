//
//  PlayerLocalCache.swift
//  Scout
//
//

import Foundation

class PlayerLocalCache {

    private var cachedItems: [Key: ItemUrl] = [:]
}

extension PlayerLocalCache: PlayerCache {

    func cachedItemUrl(for key: Key) -> ItemUrl? {
        return cachedItems[key]
    }

    func cacheItemUrl(_ url: ItemUrl, for key: Key) {
        cachedItems[key] = url
    }
}
