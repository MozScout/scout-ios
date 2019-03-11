//
//  ListenListItem.swift
//  Scout
//
//

import Foundation

struct ListenListItem: Decodable {

    let id: String
    let title: String
    let imageUrl: URL
    let url: URL
    let type: ItemType
    let logoUrl: URL?
    let duration: Int64
    let publisher: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageUrl
        case url
        case audioUrl
        case type
        case logo
        case duration
        case publisher
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        imageUrl = try container.decode(URL.self, forKey: .imageUrl)
        url = try container.decode(URL.self, forKey: .url)

        let type = try container.decode(PrivateType.self, forKey: .type)

        switch type {
        case .article:
            let url = try container.decode(URL.self, forKey: .url)
            self.type = .article(url: url)
        case .episode:
            let url = try container.decode(URL.self, forKey: .audioUrl)
            self.type = .episode(url: url)
        }

        logoUrl = try container.decodeIfPresent(URL.self, forKey: .logo)
        duration = try container.decode(Int64.self, forKey: .duration)
        publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
    }
}

extension ListenListItem {

    enum ItemType {
        case article(url: URL)
        case episode(url: URL)
    }
}

private extension ListenListItem {
    
    enum PrivateType: String, Decodable {
        case article
        case episode
    }
}
