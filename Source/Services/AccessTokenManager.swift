//
//  AccessTokenManager.swift
//  Scout
//
//

import Foundation

class AccessTokenManager {

    private var bearer: String? {
        get { return get() }
        set { set(optional: newValue) }
    }

    private let keychainManager: KeychainManager

    init(
        keychainManager: KeychainManager
        ) {

        self.keychainManager = keychainManager
    }

    func setBearerToken(_ token: String?) {
        bearer = token
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

extension AccessTokenManager: RequestAuthorizationTokenProvider {

    var bearerToken: String? {
        return bearer
    }
}
