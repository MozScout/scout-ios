//
//  ScoutTitlesHTTPClientProtocol.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/12/18.
//

import Foundation

typealias ArchiveSuccessBlock = () -> Void
typealias ScoutTitleSuccessBlock = (_ article: ScoutArticle) -> Void
typealias ScoutTitlesSuccessBlock = (_ articles: [ScoutArticle]) -> Void
typealias ScoutTitlesFailureBlock = HTTPClientFailureBlock

protocol ScoutTitlesHTTPClientProtocol {
    func getScoutTitles(withCmd cmd: String,
                        userid: String,
                        successBlock: @escaping ScoutTitlesSuccessBlock,
                        failureBlock: @escaping ScoutTitlesFailureBlock) -> HTTPClientConnectionResult

    func getArticleLink(userid: String,
                        url: String,
                        successBlock: @escaping ScoutTitleSuccessBlock,
                        failureBlock: @escaping ScoutPlayerFailureBlock) -> HTTPClientConnectionResult

    func getSummaryLink(userid: String,
                        url: String,
                        successBlock: @escaping ScoutTitleSuccessBlock,
                        failureBlock: @escaping ScoutPlayerFailureBlock) -> HTTPClientConnectionResult

    func archiveScoutTitle(withCmd cmd: String,
                           userid: String,
                           itemid: String,
                           successBlock: @escaping ArchiveSuccessBlock,
                           failureBlock: @escaping ScoutTitlesFailureBlock) -> HTTPClientConnectionResult
}
