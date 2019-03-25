//
//  DeleteListenListItemPostModel.swift
//  Scout
//
//

import Foundation

struct DeleteListenListItemPostModel: Encodable {

    let id: String
    let type: ItemType
}

extension DeleteListenListItemPostModel {

    enum ItemType: String, Encodable {
        case article
        case episode
    }
}
