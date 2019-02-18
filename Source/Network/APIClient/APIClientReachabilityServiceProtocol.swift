//
//  APIClientReachabilityServiceProtocol.swift
//  Scout
//
//

import Foundation

protocol APIClientReachabilityServiceProtocol {
    var isReachable: Bool { get }
}

extension ReachabilityService: APIClientReachabilityServiceProtocol {
    
    var isReachable: Bool {
        return isNetworkAvailable
    }
}
