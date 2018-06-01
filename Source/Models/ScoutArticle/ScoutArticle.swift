//
//  ScoutArticle.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/12/18.
//

import Foundation

func == (lhs: ScoutArticle, rhs: ScoutArticle) -> Bool {
    
    let articleIDsAreEqual = (lhs.itemID == rhs.itemID)
    let articleTitlesAreEqual = (lhs.title == rhs.title)
    let articleAuthorsAreEqual = lhs.author == rhs.author
    let articleLengthsAreEqual = lhs.lengthMinutes == rhs.lengthMinutes
    let articleSortIDAreEqual = lhs.sortID == rhs.sortID
    let resolvedURLsAreEqual = lhs.resolvedURL == rhs.resolvedURL
    let articleImageURL = lhs.articleImageURL == rhs.articleImageURL
    let url = lhs.url == rhs.url
    return articleIDsAreEqual && articleTitlesAreEqual && articleAuthorsAreEqual  && articleLengthsAreEqual && articleSortIDAreEqual && resolvedURLsAreEqual && articleImageURL && url
}

class ScoutArticle: NSObject, NSCoding {
    
    var itemID: String
    var title: String
    var author: String
    var lengthMinutes: Int
    var sortID: Int
    var resolvedURL: URL?
    var articleImageURL : URL?
    var url : String
    
    init(withArticleID itemID: String,
                        title: String,
                        author: String,
                        lengthMinutes: Int,
                        sortID: Int,
                        resolvedURL: URL?,
                        articleImageURL: URL?,
                        url: String) {
        
        self.itemID = itemID
        self.title = title
        self.author = author
        self.lengthMinutes = lengthMinutes
        self.sortID = sortID
        self.resolvedURL = resolvedURL
        self.articleImageURL = articleImageURL
        self.url = url
    }
    
    // MARK: NSCoding
    convenience required init?(coder aDecoder: NSCoder) {
        
        guard let objectDictionary = aDecoder.decodeObject(forKey: NSStringFromClass(ScoutArticle.self)) as? [String : Any],
              let itemID = objectDictionary["itemID"] as? String,
              let title = objectDictionary["title"] as? String,
              let author = objectDictionary["author"] as? String,
              let lengthMinutes = objectDictionary["lengthMinutes"] as? Int,
              let sortID = objectDictionary["sortID"] as? Int,
              let url = objectDictionary["url"] as? String
            else { return nil }
        
        var articleImageURL: URL? = nil
        if let requiredArticleImageURLString = objectDictionary["imageURL"] as? String {
            articleImageURL = URL(string: requiredArticleImageURLString)
        }
        
        var resolvedURL: URL? = nil
        if let requiredResolvedURLString = objectDictionary["resolvedURL"] as? String {
            resolvedURL = URL(string: requiredResolvedURLString)
        }
        
        self.init(withArticleID: itemID,
                  title: title,
                  author: author,
                  lengthMinutes: lengthMinutes,
                  sortID: sortID,
                  resolvedURL: resolvedURL,
                  articleImageURL: articleImageURL,
                  url: url)
    }
    
    func encode(with aCoder: NSCoder) {
        
        let dictionary = NSMutableDictionary(dictionary: [
                                                             "itemID" : itemID,
                                                             "title"   : title,
                                                             "author" : author,
                                                             "lengthMinutes" : lengthMinutes,
                                                             "sortID" : sortID,
                                                             "url"   : url,
                                                         ])
        
        if let requiredArticleImageURLString =  articleImageURL?.absoluteString { dictionary["imageURL"] = requiredArticleImageURLString }
        if let requiredResolvedURLString =  resolvedURL?.absoluteString { dictionary["resolvedURL"] = requiredResolvedURLString }
        
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
