//
//  BaseApi.swift
//  Scout
//
//

import Foundation

class BaseApi {

    let baseUrl: URL
    let apiClient: ApiClient
    let accessTokenProvider: RequestAuthorizationTokenProvider

    init(
        stack: Stack
        ) {

        self.baseUrl = stack.baseUrl
        self.apiClient = stack.apiClient
        self.accessTokenProvider = stack.accessTokenProvider
    }
}

extension BaseApi {
    struct Stack {
        let baseUrl: URL
        let apiClient: ApiClient
        let accessTokenProvider: RequestAuthorizationTokenProvider
    }
}
