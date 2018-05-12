//
//  NetworkRequestBuilder.swift
//  Scout
//
//

import Foundation
import Alamofire

class NetworkRequestBuilder: NetworkRequestBuilderProtocol {

    let baseURL: URL
    var userAuthorizationHeader: String?
    
    var manager: SessionManager!

    fileprivate let mapper: NetworkMappingProtocol
    fileprivate var baseURLString: String { return baseURL.absoluteString }
    fileprivate let headerTokenKey = "x-access-token"
    
    // MARK: Init
    init(withBaseURL baseURL: URL, mapper: NetworkMappingProtocol) {
        
        self.baseURL = baseURL
        self.mapper = mapper
    }
    
    // MARK: Auth
    func buildPostRegistrationRequest(withUserName userName: String, email: String, password: String) -> URLRequest? {
        
        let parameters = [
                             "name" : userName,
                             "email" : email,
                             "password" : password
                         ]
        
        let URLString = String(format: "http://moz-scout.herokuapp.com/api/auth/register") // need set this value in baseURL property, could work with several servers
        
        return manager.request(URLString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).request
    }
}

