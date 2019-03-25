//
//  KeychainManager.swift
//  Scout
//
//

import Foundation
import KeychainAccess

class KeychainManager {

    private let keychainStorage: Keychain

    init() {
        keychainStorage = Keychain()
    }

    // MARK: - Strings

    func save(optional: String?, for key: String) {
        switch optional {
        case .none:
            removeValue(for: key)
        case .some(let string):
            save(string: string, for: key)
        }
    }

    func save(string: String, for key: String) {
        do {
            try keychainStorage.set(string, key: key)
        } catch let error {
            print(.fatalError(error: error.localizedDescription))
        }
    }

    func string(for key: String) -> String? {
        do {
            return try keychainStorage.getString(key)
        } catch let error {
            print(.fatalError(error: error.localizedDescription))
        }
        return nil
    }

    // MARK: - Generic

    func save<Value: Encodable>(optional: Optional<Value>, for key: String) {
        switch optional {
        case .none:
            removeValue(for: key)
        case .some(let value):
            save(value: value, for: key)
        }
    }

    func save<Value: Encodable>(value: Value, for key: String) {
        do {
            let data = try value.encode()
            try keychainStorage.set(data, key: key)
        } catch let error {
            print(.fatalError(error: error.localizedDescription))
        }
    }

    func value<Value: Decodable>(for key: String) -> Value? {
        do {
            guard let data = try keychainStorage.getData(key) else {
                return nil
            }
            return try Value.decode(from: data)
        } catch let error {
            print(.fatalError(error: error.localizedDescription))
        }
        return nil
    }

    // MARK: -

    func removeValue(for key: String) {
        do {
            try keychainStorage.remove(key)
        } catch let error {
            print(.fatalError(error: error.localizedDescription))
        }
    }
}
