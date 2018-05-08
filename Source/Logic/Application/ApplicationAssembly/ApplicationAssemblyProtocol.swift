//
//  ApplicationAssemblyProtocol.swift
//  Scout
//

import Foundation

protocol ApplicationAssemblyProtocol {
    
    var configuration: AppConfiguration { get }
    
    // MARK: Routers
    func assemblyMainRouter() -> MainRoutingProtocol
    
    // MARK: Services
    func assemblyNetworkClient() -> HTTPClientProtocol
    func assemblyKeychainService() -> KeychainServiceProtocol
}
