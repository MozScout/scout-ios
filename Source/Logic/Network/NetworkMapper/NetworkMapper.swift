//
//  NetworkMapper.swift
//  Scout
//
//

import Foundation
import SwiftyJSON

public enum JSONMappingResult {
    
    case successMapping(JSON)
    case failure(JSONMappingError)
}

public enum JSONCustomMappingResult {
    
    case success(Any)
    case failure
}

public enum JSONMappingError: Error {
    
    case invalidJSON
    case unknown
    
    var description: String {
        switch self {
        case .invalidJSON:            return "InvalidJSON"
        default:                      return "Unknown"
        }
    }
}

class NetworkMapper: NetworkMappingProtocol {
    
    func scoutTitles(fromResource resource: JSON) -> [ScoutArticle]? {
        var scoutArticlesArray = [ScoutArticle]()
    
        for (_ , value) in resource["articles"] {
            
            let itemID = value["item_id"].string ?? ""
            let author = value["author"].string ?? ""
            let title = value["title"].string ?? ""
            let lengthMinutes = value["lengthMinutes"].int ?? 0
            let resolvedURL = value["resolved_url"].url ?? URL(string: "")
            let sortID = value["sort_id"].int ?? 0
            let articleImageURL = value["imageURL"].url ?? URL(string: "")
            let url = value["url"].string ?? ""
            let publisher = value["publisher"].string ?? ""
            let icon_url = value["icon_url"].url ?? URL(string: "")
            let scoutArticle = ScoutArticle(withArticleID: itemID, title: title, author: author, lengthMinutes: lengthMinutes, sortID: sortID, resolvedURL: resolvedURL, articleImageURL: articleImageURL, url: url, publisher: publisher, icon_url: icon_url)
            scoutArticlesArray.append(scoutArticle)
        }
        return scoutArticlesArray
    }
    
    func scoutAudioFileURL(fromResource resource: JSON) -> ScoutArticle {
        
        let itemID = resource["item_id"].string ?? ""
        let author = resource["author"].string ?? ""
        let title = resource["title"].string ?? ""
        let lengthMinutes = resource["lengthMinutes"].int ?? 0
        let resolvedURL = resource["resolved_url"].url ?? URL(string: "")
        let sortID = resource["sort_id"].int ?? 0
        let articleImageURL = resource["imageURL"].url ?? URL(string: "")
        let url = resource["url"].string ?? ""
        let publisher = resource["publisher"].string ?? ""
        let icon_url = resource["icon_url"].url ?? URL(string: "")
        
        let scoutArticle = ScoutArticle(withArticleID: itemID, title: title, author: author, lengthMinutes: lengthMinutes, sortID: sortID, resolvedURL: resolvedURL, articleImageURL: articleImageURL, url: url, publisher: publisher, icon_url: icon_url)
        
        return scoutArticle
    }
    
    func scoutSkimAudioFileURL(fromResource resource: JSON) -> ScoutArticle {
        
        let itemID = resource["item_id"].string ?? ""
        let author = resource["author"].string ?? ""
        let title = resource["title"].string ?? ""
        let lengthMinutes = resource["lengthMinutes"].int ?? 0
        let resolvedURL = resource["resolved_url"].url ?? URL(string: "")
        let sortID = resource["sort_id"].int ?? 0
        let articleImageURL = resource["imageURL"].url ?? URL(string: "")
        let url = resource["url"].string ?? ""
        let publisher = resource["publisher"].string ?? ""
        let icon_url = resource["icon_url"].url ?? URL(string: "")
        let scoutArticle = ScoutArticle(withArticleID: itemID, title: title, author: author, lengthMinutes: lengthMinutes, sortID: sortID, resolvedURL: resolvedURL, articleImageURL: articleImageURL, url: url, publisher: publisher, icon_url: icon_url)
        
        return scoutArticle
    }
}
