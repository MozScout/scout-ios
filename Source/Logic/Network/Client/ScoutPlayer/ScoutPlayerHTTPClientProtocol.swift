//
//  ScoutPlayerHTTPClientProtocol.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import Foundation

typealias ScoutPlayerSuccessBlock = (_ scoutArticle: ScoutArticle) -> ()
typealias ScoutPlayerFailureBlock = HTTPClientFailureBlock

protocol ScoutPlayerHTTPClientProtocol {
    func getSkimAudioFileURLFromPlayer(userid: String,
                                       url: String,
                                       successBlock: @escaping ScoutPlayerSuccessBlock,
                                       failureBlock: @escaping ScoutPlayerFailureBlock) -> HTTPClientConnectionResult
}
