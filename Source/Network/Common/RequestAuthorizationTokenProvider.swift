//
//  RequestAuthorizationTokenProvider.swift
//  Scout
//
//

import Foundation

protocol RequestAuthorizationTokenProvider {
    var bearerToken: String? { get }
}

class AccessTokenManager {

    private var bearer: String?

    func setBearerToken(_ token: String?) {
        bearer = token
    }
}

extension AccessTokenManager: RequestAuthorizationTokenProvider {

    var bearerToken: String? {
        return bearer
    }
}
