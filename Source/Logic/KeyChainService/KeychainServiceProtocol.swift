//
//  KeychainServiceProtocol.swift
//  Scout
//
//

import Foundation

protocol KeychainServiceProtocol {
    func save(value: String, key: String) -> KeychainServiceResult
    func value(for key: String) -> String?
}
