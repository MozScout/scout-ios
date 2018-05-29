//
//  ScoutHTTPClient+ScoutPlayer.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import UIKit

extension ScoutHTTPClient: ScoutPlayerHTTPClientProtocol {
    
    @discardableResult
    func getSkimAudioFileURLFromPlayer(userid: String,
                         url: String,
                         successBlock: @escaping ScoutPlayerSuccessBlock,
                         failureBlock: @escaping ScoutPlayerFailureBlock) -> HTTPClientConnectionResult {
        
        let request = self.requestBuilder.buildPostSkimRequest(userid: userid, url: url)
        
        return self.execute(request: request,
                            successBlock: { (JSONObject, customObject, response) in
                                successBlock (self.mapper.scoutAudioFileURL(fromResource: JSONObject))
        },
                            failureBlock:  { (JSONObject, clientError, response) in
                                failureBlock(JSONObject, clientError, response)
        })
    }
}

