//
//  ScoutHTTPClient+ScoutTitles.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/12/18.
//

import Foundation

extension ScoutHTTPClient: ScoutTitlesHTTPClientProtocol {

    @discardableResult
    func getScoutTitles(withCmd cmd: String,
                        userid: String,
                        successBlock: @escaping ScoutTitlesSuccessBlock,
                        failureBlock: @escaping ScoutTitlesFailureBlock) -> HTTPClientConnectionResult {

        let request = self.requestBuilder.buildPostScoutTitlesRequest(withCmd: cmd, userid: userid)

        return self.execute(request: request,
                            successBlock: { (JSONObject, _, response) in
                                successBlock (self.mapper.scoutTitles(fromResource: JSONObject)!)
                            },
                            failureBlock: { (JSONObject, clientError, response) in
                                failureBlock(JSONObject, clientError, response)
                            })
    }

    func getArticleLink(userid: String,
                        url: String,
                        successBlock: @escaping ScoutPlayerSuccessBlock,
                        failureBlock: @escaping ScoutPlayerFailureBlock) -> HTTPClientConnectionResult {

        let request = self.requestBuilder.buildPostArticleRequest(userid: userid, url: url)

        return self.execute(request: request,
                            successBlock: { (JSONObject, _, response) in
                                successBlock (self.mapper.scoutAudioFileURL(fromResource: JSONObject))
                            },
                            failureBlock: { (JSONObject, clientError, response) in
                                failureBlock(JSONObject, clientError, response)
                            })
    }

    func getSummaryLink(userid: String,
                        url: String,
                        successBlock: @escaping ScoutPlayerSuccessBlock,
                        failureBlock: @escaping ScoutPlayerFailureBlock) -> HTTPClientConnectionResult {

        let request = self.requestBuilder.buildPostSummaryRequest(userid: userid, url: url)

        return self.execute(request: request,
                            successBlock: { (JSONObject, _, response) in
                                successBlock (self.mapper.scoutAudioFileURL(fromResource: JSONObject))
                            },
                            failureBlock: { (JSONObject, clientError, response) in
                                failureBlock(JSONObject, clientError, response)
                            })
    }

    func archiveScoutTitle(withCmd cmd: String,
                           userid: String,
                           itemid: String,
                           successBlock: @escaping ArchiveSuccessBlock,
                           failureBlock: @escaping ScoutTitlesFailureBlock) -> HTTPClientConnectionResult {

        let request = self.requestBuilder.buildPostScoutTitleArchive(withCmd: cmd, userid: userid, itemid: itemid)

        return self.execute(request: request,
                            successBlock: { (JSONObject, _, response) in
                                successBlock()
                            },
                            failureBlock: { (JSONObject, clientError, response) in
                                failureBlock(JSONObject, clientError, response)
                            })
    }
}
