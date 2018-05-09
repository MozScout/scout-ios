//
//  ApplicationAssemblyProtocol.swift
//  Scout
//

import Foundation

protocol ApplicationAssemblyProtocol {
    
    var configuration: AppConfiguration { get }
    
    // MARK: Routers
    func assemblyMainRouter() -> MainRoutingProtocol
    func assemblyMyListRouter() -> MyListRoutingProtocol
    func assemblyHelpRouter() -> HelpRoutingProtocol
    func assemblySettingsRouter() -> SettingsRoutingProtocol
    
    // MARK: Services
    func assemblyNetworkClient() -> HTTPClientProtocol
    func assemblyKeychainService() -> KeychainServiceProtocol
}
