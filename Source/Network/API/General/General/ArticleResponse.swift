//
//  ArticleResponse.swift
//  Scout
//
//

import Foundation

struct ArticleResponse: Decodable {

    let title: String
    let author: String
    let lengthMinutes: Int64
    let audioUrl: URL
    let imageUrl: URL
    let publisher: String
    let excerpt: String
    let iconUrl: URL

    enum CodingKeys: String, CodingKey {
        case title
        case author
        case lengthMinutes
        case audioUrl
        case imageUrl = "imageURL"
        case publisher
        case excerpt
        case iconUrl
    }
}
