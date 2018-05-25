//
//  ScoutHTTPClient+ScoutVoiceInput.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import UIKit

extension ScoutHTTPClient: ScoutVoiceInputHTTPClientProtocol {
    
    @discardableResult
    func getAudioFileURL(withCmd cmd: String,
                        userid: String,
                        searchTerms: String,
                        successBlock: @escaping ScoutVoiceInputSuccessBlock,
                        failureBlock: @escaping ScoutVoiceInputFailureBlock) -> HTTPClientConnectionResult {
        
        let request = self.requestBuilder.buildPostScoutVoiceInputRequest(withCmd: cmd, userid: userid, searchTerms: searchTerms)
        
        return self.execute(request: request,
                            successBlock: { (JSONObject, customObject, response) in
                                successBlock (self.mapper.scoutAudioFileURL(fromResource: JSONObject))
        },
                            failureBlock:  { (JSONObject, clientError, response) in
                                
        })
    }
    
    func getSkimAudioFileURL(withCmd cmd: String,
                         userid: String,
                         searchTerms: String,
                         successBlock: @escaping ScoutVoiceInputSuccessBlock,
                         failureBlock: @escaping ScoutVoiceInputFailureBlock) -> HTTPClientConnectionResult {
        
        let request = self.requestBuilder.buildPostScoutSkimVoiceInputRequest(withCmd: cmd, userid: userid, searchTerms: searchTerms)
        
        return self.execute(request: request,
                            successBlock: { (JSONObject, customObject, response) in
                                successBlock (self.mapper.scoutAudioFileURL(fromResource: JSONObject))
        },
                            failureBlock:  { (JSONObject, clientError, response) in
                                
        })
    }
}

