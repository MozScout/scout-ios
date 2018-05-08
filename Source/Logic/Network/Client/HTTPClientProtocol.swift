//
//  HTTPClientProtocol.swift
//  Scout
//
//

import Foundation
import SwiftyJSON

protocol HTTPClientConnectionStateControlProtocol {
    
    func resume()
    func suspend()
    func cancel()
}

typealias HTTPClientConnectionResult = HTTPClientConnectionStateControlProtocol?

typealias HTTPClientSuccessBlock = (_ successResponse: JSON, _ mappedObject: Any?, _ response: HTTPURLResponse?) -> ()
typealias HTTPClientFailureBlock = (_ failureResponse: JSON?, _ error: HTTPClientError, _ response: HTTPURLResponse?) -> ()

protocol HTTPClientProtocol: class {
    
    @discardableResult
    func execute(request: URLRequest?,
                 successBlock: @escaping HTTPClientSuccessBlock,
                 failureBlock: @escaping HTTPClientFailureBlock ) -> HTTPClientConnectionResult
    
    func cancelAllRequests()
}
