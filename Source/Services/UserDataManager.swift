//
//  UserDataManager.swift
//  Scout
//
//

import Foundation

protocol UserDataProvider {

    var userId: String? { get }
}

class UserDataManager {

    public var userId: String? {
        get { return get() }
        set { set(optional: newValue) }
    }

    private let keychainManager: KeychainManager

    init(
        keychainManager: KeychainManager
        ) {

        self.keychainManager = keychainManager
    }

    // MARK: - Private methods

    private func set(
        optional: String?,
        for key: String = #function
        ) {

        let key = keychainKey(from: key)
        keychainManager.save(optional: optional, for: key)
    }

    private func get(
        for key: String = #function
        ) -> String? {

        let key = keychainKey(from: key)
        return keychainManager.string(for: key)
    }

    private func keychainKey(from key: String) -> String {
        return key
    }
}

extension UserDataManager: UserDataProvider { }
