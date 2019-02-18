//
//  API.swift
//  Scout
//
//

import Foundation

class API {

    private let url: URL
    private let apiClient: APIClient

    private(set) lazy var topicsApi: TopicsApi = {
        return createTopicsApi()
    }()

    init(
        url: URL,
        apiClient: APIClient
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
