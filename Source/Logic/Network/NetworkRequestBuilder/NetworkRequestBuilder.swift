//
//  NetworkRequestBuilder.swift
//  Scout
//
//

import Foundation
import Alamofire

class NetworkRequestBuilder: NetworkRequestBuilderProtocol {

    let baseURL: URL
    fileprivate var manager: SessionManager

    // MARK: Init
    init(baseURL: URL,
         manager: SessionManager) {
        
        self.baseURL = baseURL
        self.manager = manager
    }
}

