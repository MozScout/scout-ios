//
//  ApiClientReachabilityServiceProtocol.swift
//  Scout
//
//

import Foundation

protocol ApiClientReachabilityServiceProtocol {
    
    var isReachable: Bool { get }
}

extension ReachabilityService: ApiClientReachabilityServiceProtocol {
    
    var isReachable: Bool {
        return isNetworkAvailable
    }
}
