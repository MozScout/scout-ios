//
//  AppAssembly.swift
//  Scout
//
//

import Foundation

class AppAssembly {

    private lazy var url: URL = {
        return AppConfiguration().network.baseURL
    }()

    private lazy var reachabilityService: ReachabilityService = {
        return ReachabilityService()
    }()

    private lazy var apiClient: ApiClient = {
        return ApiClient(reachabilityService: reachabilityService)
    }()

    private lazy var accessTokenManager: AccessTokenManager = {
        return AccessTokenManager()
    }()

    private var accessTokenProvider: RequestAuthorizationTokenProvider {
        return accessTokenManager
    }

    private lazy var api: Api = {
        return Api(
            url: url,
            apiClient: apiClient,
            accessTokenProvider: accessTokenProvider
        )
    }()

    func assemblyApi() -> Api {
        return api
    }

    func assemblyAccessTokenManager() -> AccessTokenManager {
        return accessTokenManager
    }

    func assemblyAccessTokenProvider() -> RequestAuthorizationTokenProvider {
        return accessTokenProvider
    }

    func assemblyOnboardingFlowCoordinatorAssembly() -> OnboardingFlowCoordinator.Assembly {
        return OnboardingFlowCoordinator.Assembly(appAssembly: self)
    }

    func assemblyTabBarFlowCoordinatorAssembly() -> TabBarFlowCoordinator.Assembly {
        return TabBarFlowCoordinator.Assembly(appAssembly: self)
    }

    func assemblyListenFlowCoordinatorAssembly() -> ListenFlowCoordinator.Assembly {
        return ListenFlowCoordinator.Assembly(appAssembly: self)
    }
}
