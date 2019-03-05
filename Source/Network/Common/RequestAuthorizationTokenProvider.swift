//
//  RequestAuthorizationTokenProvider.swift
//  Scout
//
//

import Foundation

protocol RequestAuthorizationTokenProvider {
    var bearerToken: String? { get }
}
