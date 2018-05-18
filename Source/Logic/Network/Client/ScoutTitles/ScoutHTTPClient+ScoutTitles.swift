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
                            successBlock: { (JSONObject, customObject, response) in
                                successBlock (self.mapper.scoutTitles(fromResource: JSONObject)!)
                        },
                            failureBlock:  { (JSONObject, clientError, response) in
                                
        })
    }
}
