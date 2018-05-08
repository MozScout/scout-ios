//
//  AppConfiguration.swift
//  Scout
//
//

import Foundation

class AppConfiguration {
    
    let network: Network
    
    convenience init() {
        
        self.init(with: AppConfigurationBridge())
    }
    
    init(with bridge: AppConfigurationBridge) {
        
        self.network = Network(baseURL: URL(string: bridge.scoutBaseURL)!)
    }
}

extension AppConfiguration {
    
    struct Network {
        
        let baseURL: URL
    }
    
    
}
