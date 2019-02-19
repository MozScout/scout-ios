//
//  Api.swift
//  Scout
//
//

import Foundation

class Api {

    private let url: URL
    private let apiClient: ApiClient

    private(set) lazy var topicsApi: TopicsApi = {
        return createTopicsApi()
    }()

    init(
        url: URL,
        apiClient: ApiClient
        ) {

        self.url = url
        self.apiClient = apiClient
    }

    private func createTopicsApi() -> TopicsApi {
        return TopicsApi(
            baseUrl: url,
            apiClient: apiClient
        )
    }
}
