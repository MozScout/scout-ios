//
//  ScoutArticle.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/12/18.
//

import Foundation

func == (lhs: ScoutArticle, rhs: ScoutArticle) -> Bool {
    
    let articleIDsAreEqual = (lhs.item_id == rhs.item_id)
    let articleTitlesAreEqual = (lhs.title == rhs.title)
    let articleAuthorsAreEqual = lhs.author == rhs.author
    let articleLengthsAreEqual = lhs.lengthMinutes == rhs.lengthMinutes
    let articleSortIDAreEqual = lhs.sort_id == rhs.sort_id
    let resolvedURLsAreEqual = lhs.resolved_url == rhs.resolved_url
    
    return articleIDsAreEqual && articleTitlesAreEqual && articleAuthorsAreEqual  && articleLengthsAreEqual && articleSortIDAreEqual && resolvedURLsAreEqual
}

class ScoutArticle: NSObject, NSCoding {
    
    var item_id: String
    var title: String
    var author: String
    var lengthMinutes: Int
    var sort_id: Int
    var resolved_url: URL?
    
    init(withArticleID item_id: String,
                    title: String,
                   author: String,
                   lengthMinutes: Int,
                 sort_id: Int,
                     resolved_url: URL?) {
        
        self.item_id = item_id
        self.title = title
        self.author = author
        self.lengthMinutes = lengthMinutes
        self.sort_id = sort_id
        self.resolved_url = resolved_url
    }
    
    // MARK: NSCoding
    convenience required init?(coder aDecoder: NSCoder) {
        
        guard let objectDictionary = aDecoder.decodeObject(forKey: NSStringFromClass(ScoutArticle.self)) as? [String : Any],
              let item_id = objectDictionary["item_id"] as? String,
              let title = objectDictionary["title"] as? String,
              let author = objectDictionary["author"] as? String,
              let lengthMinutes = objectDictionary["lengthMinutes"] as? Int,
            let sort_id = objectDictionary["sort_id"] as? Int
            else { return nil }
        
        /*var articleImageURL: URL? = nil
        if let requiredArticleImageURLString = objectDictionary["articleImageURL"] as? String {
            articleImageURL = URL(string: requiredArticleImageURLString)
        }*/
        
        var resolvedURL: URL? = nil
        if let requiredResolvedURLString = objectDictionary["resolved_url"] as? String {
            resolvedURL = URL(string: requiredResolvedURLString)
        }
        
        self.init(withArticleID: item_id,
                  title: title,
                  author: author,
                  lengthMinutes: lengthMinutes,
                  sort_id: sort_id,
                  resolved_url: resolvedURL)
    }
    
    func encode(with aCoder: NSCoder) {
        
        let dictionary = NSMutableDictionary(dictionary: [
                                                             "item_id" : item_id,
                                                             "title"   : title,
                                                             "author" : author,
                                                             "lengthMinutes" : lengthMinutes,
                                                             "sort_id" : sort_id
                                                         ])
        
        /*if let requiredArticleImageURLString =  articleImageURL?.absoluteString { dictionary["articleImageURL"] = requiredArticleImageURLString }*/
        if let requiredResolvedURLString =  resolved_url?.absoluteString { dictionary["resolved_url"] = requiredResolvedURLString }
        
        aCoder.encode(dictionary, forKey: NSStringFromClass(ScoutArticle.self))
    }
    
    // MARK: Equal
    override func isEqual(_ object: Any?) -> Bool {
        
        guard let requiredObject = object,
              let comparableObject = requiredObject as? ScoutArticle
        else { return false }
        
        return self == comparableObject
    }
}
