//
//  NetworkRequestBuilder.swift
//  Scout
//
//

import Alamofire
import Foundation

class NetworkRequestBuilder: NetworkRequestBuilderProtocol {
    let baseURL: URL
    var userAuthorizationHeader: String?

    var manager: SessionManager!

    fileprivate let mapper: NetworkMappingProtocol
    fileprivate var baseURLString: String { return baseURL.absoluteString }
    fileprivate let headerTokenKey = "x-access-token"
    fileprivate let token = """
    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjFhYTAyZTg4LTNkY2ItNGM3Yi1hNDMyLWQzOGFkN2NiNGYwNiIsImlhdCI6MTUyODMyO\
    DYxMn0.IfV2hmxD90qOfHBkhur6PRRI4PBBiXwA5pvAdt1AUHI
    """

    // MARK: Init
    init(withBaseURL baseURL: URL, mapper: NetworkMappingProtocol) {
        self.baseURL = baseURL
        self.mapper = mapper
    }

    // MARK: Auth
    func buildPostRegistrationRequest(withUserName userName: String, email: String, password: String) -> URLRequest? {
        let parameters = [
            "name": userName,
            "email": email,
            "password": password
        ]

        let URLString = String(format: "%@api/auth/register", self.baseURLString)

        return manager.request(URLString,
                               method: .post,
                               parameters: parameters,
                               encoding: JSONEncoding.default,
                               headers: nil).request
    }

    func buildPostScoutTitlesRequest(withCmd cmd: String, userid: String) -> URLRequest? {
        let parameters = [
            "cmd": cmd,
            "userid": userid,
            "extendedData": "1"
        ]

        let headers = [headerTokenKey: token]
        let URLString = String(format: "%@command/intent", self.baseURLString)

        return manager.request(URLString,
                               method: .post,
                               parameters: parameters,
                               encoding: URLEncoding(),
                               headers: headers).request
    }

    func buildPostScoutVoiceInputRequest(withCmd cmd: String,
                                         userid: String,
                                         searchTerms: String) -> URLRequest? {
        let parameters = [
            "cmd": cmd,
            "userid": userid,
            "searchTerms": searchTerms,
            "extendedData": "1"
        ]

        let headers = [headerTokenKey: token]
        let URLString = String(format: "%@command/intent", self.baseURLString)

        return manager.request(URLString,
                               method: .post,
                               parameters: parameters,
                               encoding: URLEncoding(),
                               headers: headers).request
    }

    func buildPostScoutSkimVoiceInputRequest(withCmd cmd: String, userid: String, searchTerms: String) -> URLRequest? {
        let parameters = [
            "cmd": cmd,
            "userid": userid,
            "searchTerms": searchTerms,
            "extendedData": "1"
        ]

        let headers = [headerTokenKey: token]
        let URLString = String(format: "%@command/intent", self.baseURLString)

        return manager.request(URLString,
                               method: .post,
                               parameters: parameters,
                               encoding: URLEncoding(),
                               headers: headers).request
    }

    func buildPostArticleRequest(userid: String, url: String) -> URLRequest? {
        let parameters = [
            "userid": userid,
            "url": url,
            "extendedData": "1"
        ]

        let headers = [headerTokenKey: token]
        let URLString = String(format: "%@command/article", self.baseURLString)

        return manager.request(URLString,
                               method: .post,
                               parameters: parameters,
                               encoding: URLEncoding(),
                               headers: headers).request
    }

    func buildPostSummaryRequest(userid: String, url: String) -> URLRequest? {
        let parameters = [
            "userid": userid,
            "url": url,
            "extendedData": "1"
        ]

        let headers = [headerTokenKey: token]
        let URLString = String(format: "%@command/summary", self.baseURLString)

        return manager.request(URLString,
                               method: .post,
                               parameters: parameters,
                               encoding: URLEncoding(),
                               headers: headers).request
    }

    func buildPostScoutTitleArchive(withCmd cmd: String, userid: String, itemid: String) -> URLRequest? {
        let parameters = [
            "cmd": cmd,
            "userid": userid,
            "itemid": itemid
        ]

        let headers = [headerTokenKey: token]
        let URLString = String(format: "%@command/intent", self.baseURLString)

        return manager.request(URLString,
                               method: .post,
                               parameters: parameters,
                               encoding: URLEncoding(),
                               headers: headers).request
    }
}
