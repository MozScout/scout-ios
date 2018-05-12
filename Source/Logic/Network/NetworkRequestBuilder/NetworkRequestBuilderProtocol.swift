//
//  NetworkRequestBuilderProtocol.swift
//  Scout
//
//

import Foundation

protocol NetworkRequestBuilderProtocol {
    
    var baseURL: URL { get }
    
    // MARK: Auth
    func buildPostRegistrationRequest(withUserName userName: String, email: String, password: String) -> URLRequest?
}
