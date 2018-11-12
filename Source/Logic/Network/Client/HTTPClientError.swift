//
//  HTTPClientError.swift
//  Scout
//
//

import Foundation

enum HTTPClientError {
    case invalidRequest
    case badResponse
    case jsonSerialization
    case connectionError(reason: String)
    case tokenExpiration
    case unknown

     var description: String { return self.toString }

     var toString: String {
        switch self {
            case .invalidRequest:
                return "InvalidRequest"
            case .badResponse:
                return "BadResponse"
            case .jsonSerialization:
                return "jsonSerialization"
            case .connectionError(let reason):
                return "ConnectionError-\(reason)"
            case .tokenExpiration:
                return "TokenExpiration"
            case .unknown:
                return "Unknown"
        }
    }

     static func from(string: String) -> HTTPClientError? {
        let components = string.components(separatedBy: "-")

        switch components.first ?? "" {
            case "InvalidRequest":
                return HTTPClientError.invalidRequest
            case "BadResponse":
                return HTTPClientError.badResponse
            case "jsonSerialization":
                return HTTPClientError.jsonSerialization
            case "TokenExpiration":
                return HTTPClientError.tokenExpiration
            case "ConnectionError":
                var reason = "Unknown"
                if components.count >= 2 { reason = components[1] }
                return HTTPClientError.connectionError(reason: reason)
            default:
                return nil
        }
    }
}
