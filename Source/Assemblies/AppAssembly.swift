//
//  AppAssembly.swift
//  Scout
//
//

import Foundation

class AppAssembly {

    private let url: URL

    private lazy var reachabilityService: ReachabilityService = {
        return ReachabilityService()
    }()

    private lazy var apiClient: ApiClient = {
        return ApiClient(reachabilityService: reachabilityService)
    }()

    private lazy var api: Api = {
        return Api(
            url: url,
            apiClient: apiClient
        )
    }()

    init(with url: URL) {

        self.url = url
    }

    func assemblyApi() -> Api {
        return api
    }

    func assemblyOnboardingFlowCoordinatorAssembly() -> OnboardingFlowCoordinator.Assembly {
        return OnboardingFlowCoordinator.Assembly(appAssembly: self)
    }

    func assemblyTabBarFlowCoordinatorAssembly() -> TabBarFlowCoordinator.Assembly {
        return TabBarFlowCoordinator.Assembly(appAssembly: self)
    }
}
