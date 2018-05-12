//
//  NetworkMapper.swift
//  Scout
//
//

import Foundation
import SwiftyJSON

public enum JSONMappingResult {
    
    case successMapping(JSON)
    case failure(JSONMappingError)
}

public enum JSONCustomMappingResult {
    
    case success(Any)
    case failure
}

public enum JSONMappingError: Error {
    
    case invalidJSON
    case unknown
    
    var description: String {
        switch self {
        case .invalidJSON:            return "InvalidJSON"
        default:                      return "Unknown"
        }
    }
}

class NetworkMapper: NetworkMappingProtocol {
    
    
}
