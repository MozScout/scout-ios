//
//  KeychainService.swift
//  Scout
//
//

import Foundation
import KeychainAccess

enum KeychainServiceResult {
    
    case success
    case failure(reason: String)
}

class KeychainService: KeychainServiceProtocol {

    private let firstLaunchKey = "KeychainService.isNotFirstLaunch"
    private let keychainStorage: Keychain
    
    required init(with identifier: String) {
        
        let keychain = Keychain(service: identifier).accessibility(.afterFirstUnlockThisDeviceOnly)
        self.keychainStorage = keychain
        
        self.removeAllIfNeeded()
    }
    
    func save(value: String, key: String) -> KeychainServiceResult {

        do {
            try self.keychainStorage.set(value, key: key)
            return .success
        }
        catch let error {
            return .failure(reason: error.localizedDescription)
        }
    }
    
    func value(for key: String) -> String? {
        
        do {
            let result = try self.keychainStorage.get(key)
            return result
        }
        catch let error {
            
            print(error)
            return nil
        }
    }
}

// MARK: -
// MARK: Private
fileprivate extension KeychainService {
    
    func removeAllIfNeeded() {
        
        let userDefaults = UserDefaults.standard
        let isNotFirstLaunch = userDefaults.bool(forKey: self.firstLaunchKey)
        
        guard isNotFirstLaunch == false else { return }
        
        do {
            try self.keychainStorage.removeAll()
        }
        catch let error {
            
            print(error.localizedDescription)
        }
        
        userDefaults.set(true, forKey: self.firstLaunchKey)
        userDefaults.synchronize()
    }
}
