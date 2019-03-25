//
//  PlayerCache.swift
//  Scout
//
//

import Foundation

protocol PlayerCache {

    typealias Key = URL
    typealias ItemUrl = URL
    
    func cachedItemUrl(for key: Key) -> ItemUrl?
    func cacheItemUrl(_ url: ItemUrl, for key: Key)
}
