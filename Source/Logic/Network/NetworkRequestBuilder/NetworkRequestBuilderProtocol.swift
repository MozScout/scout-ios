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
    func buildPostScoutTitlesRequest(withCmd cmd: String, userid: String) -> URLRequest?
    func buildPostScoutVoiceInputRequest(withCmd cmd: String, userid: String, searchTerms: String) -> URLRequest?
    func buildPostSkimRequest(userid: String, url: String) -> URLRequest?
    func buildPostScoutSkimVoiceInputRequest(withCmd cmd: String, userid: String, searchTerms: String) -> URLRequest?
}
