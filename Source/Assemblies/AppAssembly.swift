//
//  AppAssembly.swift
//  Scout
//
//

import Foundation

class AppAssembly {

    // MARK: - Private properties -

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
        return AccessTokenManager(keychainManager: keychainManager)
    }()

    private var accessTokenProvider: RequestAuthorizationTokenProvider {
        return accessTokenManager
    }

    private lazy var keychainManager: KeychainManager = {
        return KeychainManager()
    }()

    private lazy var userDataManager: UserDataManager = {
        return UserDataManager(keychainManager: keychainManager)
    }()

    private var userDataProvider: UserDataProvider {
        return userDataManager
    }

    private lazy var playerService: PlayerService = {
        return PlayerService()
    }()

    private lazy var playerManager: PlayerManager = {
        return PlayerManager(playerService: playerService, generalApi: api.generalApi)
    }()

    private lazy var listenListRepo: ListenListRepo = {
        return ListenListRepo(listenListApi: api.listenListApi)
    }()

    private lazy var api: Api = {
        return Api(
            url: url,
            apiClient: apiClient,
            accessTokenProvider: accessTokenProvider
        )
    }()

    // MARK: - Dependencies Assemblies -

    func assemblyApi() -> Api {
        return api
    }

    func assemblyAccessTokenManager() -> AccessTokenManager {
        return accessTokenManager
    }

    func assemblyAccessTokenProvider() -> RequestAuthorizationTokenProvider {
        return accessTokenProvider
    }

    func assemblyUserDataManager() -> UserDataManager {
        return userDataManager
    }

    func assemblyPlayerService() -> PlayerService {
        return playerService
    }

    func assemblyPlayerManager() -> PlayerManager {
        return playerManager
    }

    func assemblyListenListRepo() -> ListenListRepo {
        return listenListRepo
    }

    // MARK: - Flow Coordinators Assemblies -

    func assemblyOnboardingFlowCoordinatorAssembly() -> OnboardingFlowCoordinator.Assembly {
        return OnboardingFlowCoordinator.Assembly(appAssembly: self)
    }

    func assemblyTabBarFlowCoordinatorAssembly() -> TabBarFlowCoordinator.Assembly {
        return TabBarFlowCoordinator.Assembly(appAssembly: self)
    }

    func assemblyListenFlowCoordinatorAssembly() -> ListenFlowCoordinator.Assembly {
        return ListenFlowCoordinator.Assembly(appAssembly: self)
    }

    // MARK: - Assemblies -

    func assemblyAppCoordinatorStartInstructor() -> AppCoordinator.LaunchInstructor {
        return AppCoordinator.LaunchInstructor(
            userDataProvider: userDataProvider,
            authTokenProvider: accessTokenProvider
        )
    }
}
