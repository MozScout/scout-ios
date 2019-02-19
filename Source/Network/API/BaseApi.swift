//
//  BaseApi.swift
//  Scout
//
//

import Foundation
import Moya

class BaseApi {

    let baseUrl: URL
    let apiClient: ApiClient

    init(
        baseUrl: URL,
        apiClient: ApiClient
        ) {

        self.baseUrl = baseUrl
        self.apiClient = apiClient
    }
}
