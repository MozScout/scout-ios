//
//  ApplicationAssembly.swift
//  Scout
//
//

import Foundation
import Alamofire
class ApplicationAssembly {
    
    // MARK: Properties
    let configuration: AppConfiguration
    
    fileprivate lazy var authRouter: AuthRoutingProtocol = self.createAuthRouter()
    fileprivate lazy var mainRouter: MainRoutingProtocol = self.createMainRouter()
    fileprivate lazy var myListRouter: MyListRoutingProtocol = self.createMyListRouter()
    fileprivate lazy var helpRouter: HelpRoutingProtocol = self.createHelpRouter()
    fileprivate lazy var settingsRouter: SettingsRoutingProtocol = self.createSettingsRouter()

    fileprivate lazy var networkClient: HTTPClientProtocol = self.createNetworkClient()
    fileprivate lazy var networkManager: SessionManager = self.createSessionManager()
    fileprivate lazy var keychainService: KeychainServiceProtocol = self.createKeychainService()
    fileprivate lazy var voiceInputRouter: VoiceInputRoutingProtocol = self.createVoiceInputRouter()

    // MARK: Init
    required init(with configuration: AppConfiguration) {
        
        self.configuration = configuration
    }
}

// MARK: -
// MARK: ApplicationAssemblyProtocol
extension ApplicationAssembly: ApplicationAssemblyProtocol {
    func assemblyAuthRouter() -> AuthRoutingProtocol { return self.authRouter}
    func assemblyMainRouter() -> MainRoutingProtocol { return self.mainRouter }
    func assemblyMyListRouter() -> MyListRoutingProtocol { return self.myListRouter }
    func assemblyHelpRouter() -> HelpRoutingProtocol { return self.helpRouter }
    func assemblySettingsRouter() -> SettingsRoutingProtocol { return self.settingsRouter }
    func assemblyVoiceInputRouter() -> VoiceInputRoutingProtocol { return self.voiceInputRouter }
    
    func assemblyNetworkClient() -> HTTPClientProtocol { return self.networkClient }
    func assemblyKeychainService() -> KeychainServiceProtocol { return self.keychainService }
}

// MARK: -
// MARK: Private
fileprivate extension ApplicationAssembly {

    func createSessionManager() -> SessionManager {
        
        let networkRequestTimeOutInterval: TimeInterval = 30
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = networkRequestTimeOutInterval
        configuration.timeoutIntervalForResource = networkRequestTimeOutInterval
        
        let networkManager = Alamofire.SessionManager(configuration: configuration)
        networkManager.startRequestsImmediately = false
        
        return networkManager
    }

    // MARK: Routers
    func createAuthRouter() -> AuthRoutingProtocol {
        
        let authAssembly = AuthAssembly(withAssembly: self)
        return AuthRouter(with: authAssembly)
    }
    
    func createMainRouter() -> MainRoutingProtocol {
        
        let mainAssembly = MainAssembly(withAssembly: self)
        let mainRouter = MainUIRouter(withApplicationAssembly: self, assembly: mainAssembly)
        
        return mainRouter
    }

    func createMyListRouter() -> MyListRoutingProtocol {
        
        let myListAssembly = MyListAssembly(withAssembly: self)
        return MyListRouter(with: myListAssembly)
    }
    
    func createHelpRouter() -> HelpRoutingProtocol {
        
        let helpAssembly = HelpAssembly(withAssembly: self)
        return HelpRouter(with: helpAssembly)
    }
    
    func createSettingsRouter() -> SettingsRoutingProtocol {
        
        let settingsAssembly = SettingsAssembly(withAssembly: self)
        return SettingsRouter(with: settingsAssembly)
    }
    
    func createVoiceInputRouter() -> VoiceInputRoutingProtocol {
        
        let voiceInputAssembly = VoiceInputAssemly(withAssembly: self)
        return VoiceInputRouter(with: voiceInputAssembly)
    }
    
    // MARK: Services
    func createNetworkClient() -> HTTPClientProtocol {
        
        let networkMapper = NetworkMapper()
        let requestBuilder = NetworkRequestBuilder(withBaseURL: configuration.network.baseURL,
                                                        mapper: networkMapper)
        requestBuilder.manager = self.networkManager
        
        let networkClient = ScoutHTTPClient(with: networkMapper,
                                  requestBuilder: requestBuilder,
                                         manager: self.networkManager)

        return networkClient
    }
    
    func createKeychainService() -> KeychainServiceProtocol {
        
        let bundleID = Bundle.main.bundleIdentifier ?? ""
        let keychainService = KeychainService(with: bundleID)
        return keychainService
    }
}
