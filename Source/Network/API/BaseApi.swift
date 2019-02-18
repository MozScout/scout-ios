//
//  BaseApi.swift
//  Scout
//
//

import Foundation
import Moya

class BaseApi {

    let baseUrl: URL
    let apiClient: APIClient

    init(
        baseUrl: URL,
        apiClient: APIClient
        ) {

        self.baseUrl = baseUrl
        self.apiClient = apiClient
    }
}
