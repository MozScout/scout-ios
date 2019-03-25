//
//  Api.swift
//  Scout
//
//

import Foundation

class Api {

    private let baseApiStack: BaseApi.Stack

    private let url: URL
    private let apiClient: ApiClient
    private let accessTokenProvider: RequestAuthorizationTokenProvider

    private(set) lazy var topicsApi: TopicsApi = {
        return createTopicsApi()
    }()

    private(set) lazy var registerApi: RegisterApi = {
        return createRegisterApi()
    }()

    private(set) lazy var listenListApi: ListenListApi = {
        return createListenListApi()
    }()

    private(set) lazy var generalApi: GeneralApi = {
        return createGeneralApi()
    }()

    init(
        url: URL,
        apiClient: ApiClient,
        accessTokenProvider: RequestAuthorizationTokenProvider
        ) {

        self.url = url
        self.apiClient = apiClient
        self.accessTokenProvider = accessTokenProvider

        baseApiStack = BaseApi.Stack(
            baseUrl: url,
            apiClient: apiClient,
            accessTokenProvider: accessTokenProvider
        )
    }

    private func createTopicsApi() -> TopicsApi {
        return TopicsApi(stack: baseApiStack)
    }

    private func createRegisterApi() -> RegisterApi {
        return RegisterApi(stack: baseApiStack)
    }

    private func createListenListApi() -> ListenListApi {
        return ListenListApi(stack: baseApiStack)
    }

    private func createGeneralApi() -> GeneralApi {
        return GeneralApi(stack: baseApiStack)
    }
}
