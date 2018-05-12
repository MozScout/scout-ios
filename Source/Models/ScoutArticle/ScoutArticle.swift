//
//  ScoutArticle.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/12/18.
//

import Foundation

func == (lhs: ScoutArticle, rhs: ScoutArticle) -> Bool {
    
    let articleIDsAreEqual = (lhs.articleID == rhs.articleID)
    let articleTitlesAreEqual = (lhs.articleTitle == rhs.articleTitle)
    let articleAuthorsAreEqual = lhs.articleAuthor == rhs.articleAuthor
    let articleLengthsAreEqual = lhs.articleLength == rhs.articleLength
    let articleImageURLsAreEqual = lhs.articleImageURL == rhs.articleImageURL
    let resolvedURLsAreEqual = lhs.resolvedURL == rhs.resolvedURL
    
    return articleIDsAreEqual && articleTitlesAreEqual && articleAuthorsAreEqual  && articleLengthsAreEqual && articleImageURLsAreEqual && resolvedURLsAreEqual
}

class ScoutArticle: NSObject, NSCoding {
    
    var articleID: String
    var articleTitle: String
    var articleAuthor: String
    var articleLength: Int
    var articleImageURL: URL?
    var resolvedURL: URL?
    
    init(withArticleID articleID: String,
                    articleTitle: String,
                   articleAuthor: String,
                   articleLength: Int,
                 articleImageURL: URL?,
                     resolvedURL: URL?) {
        
        self.articleID = articleID
        self.articleTitle = articleTitle
        self.articleAuthor = articleAuthor
        self.articleLength = articleLength
        self.articleImageURL = articleImageURL
        self.resolvedURL = resolvedURL
    }
    
    // MARK: NSCoding
    convenience required init?(coder aDecoder: NSCoder) {
        
        guard let objectDictionary = aDecoder.decodeObject(forKey: NSStringFromClass(ScoutArticle.self)) as? [String : Any],
              let articleID = objectDictionary["articleID"] as? String,
              let articleTitle = objectDictionary["articleTitle"] as? String,
              let articleAuthor = objectDictionary["articleAuthor"] as? String,
              let articleLength = objectDictionary["articleLength"] as? Int
        else { return nil }
        
        var articleImageURL: URL? = nil
        if let requiredArticleImageURLString = objectDictionary["articleImageURL"] as? String {
            articleImageURL = URL(string: requiredArticleImageURLString)
        }
        
        var resolvedURL: URL? = nil
        if let requiredResolvedURLString = objectDictionary["resolvedURL"] as? String {
            resolvedURL = URL(string: requiredResolvedURLString)
        }
        
        self.init(withArticleID: articleID,
                   articleTitle: articleTitle,
                  articleAuthor: articleAuthor,
                  articleLength: articleLength,
                articleImageURL: articleImageURL,
                    resolvedURL: resolvedURL)
    }
    
    func encode(with aCoder: NSCoder) {
        
        let dictionary = NSMutableDictionary(dictionary: [
                                                             "articleID" : articleID,
                                                             "articleTitle"   : articleTitle,
                                                             "articleAuthor" : articleAuthor,
                                                             "articleLength" : articleLength
                                                         ])
        
        if let requiredArticleImageURLString =  articleImageURL?.absoluteString { dictionary["articleImageURL"] = requiredArticleImageURLString }
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
