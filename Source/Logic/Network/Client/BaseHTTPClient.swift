//
//  BaseHTTPClient.swift
//  Scout
//
//


import Foundation
import Alamofire
import SwiftyJSON

extension Request: HTTPClientConnectionStateControlProtocol {}

class BaseHTTPClient: HTTPClientProtocol {

    var adapters: [RequestAdapter]?

    fileprivate var manager: SessionManager
    fileprivate let networkProcessingQueue = DispatchQueue(label: "com.httpClient.networkqueue", attributes: DispatchQueue.Attributes.concurrent)

    init(withManager manager: SessionManager, adapters: [RequestAdapter]? = nil) {
        
        self.manager = manager
        self.adapters = adapters
    }

    func execute(request: URLRequest?,
            successBlock: @escaping HTTPClientSuccessBlock,
            failureBlock: @escaping HTTPClientFailureBlock ) -> HTTPClientConnectionResult {
        
        guard let requiredRequest = request else {

            failureBlock(nil, .invalidRequest, nil)
            return nil
        }
        
        let preparedRequest = self.adapted(request: requiredRequest, usingAdapters: adapters)
        
        let afRequest: DataRequest = manager.request(preparedRequest)
        afRequest.resume()

        afRequest.validate().response(queue: self.networkProcessingQueue) { (dataResponse) in
            
            let response = dataResponse.response
            let error: NSError? = dataResponse.error as NSError?

            guard let validResponse = response else {
                
                if let requiredError = error {
                    
                    if let urlError = requiredError as? URLError {
                        
                        var errorReason = ""
                        switch urlError {
                        case URLError.timedOut:              errorReason = "Time Out"
                        case URLError.cannotFindHost:        errorReason = "Cannot find host"
                        case URLError.cannotConnectToHost:   errorReason = "Cannot connect to host"
                        case URLError.networkConnectionLost: errorReason = "Network connection lost"
                        case URLError.dnsLookupFailed:       errorReason = "DNS lookup failed"
                        default:                             errorReason = urlError.localizedDescription
                        }
                        
                        failureBlock(nil, .connectionError(reason: errorReason), dataResponse.response)
                        return
                    }
                }
                
                failureBlock(nil, .badResponse, dataResponse.response)
                return
            }

            guard let validData = dataResponse.data else {
                
                failureBlock(nil, .badResponse, validResponse)
                return
            }
            
            do {
            
                let object: Any = try JSONSerialization.jsonObject(with: validData, options: .allowFragments)
                let JSONObject = JSON(object)
                successBlock(JSONObject, nil, validResponse)
            }
            catch let error {
                
                print(error.localizedDescription)
                
                failureBlock(nil, .jsonSerialization, validResponse)
            }
        }
        
        return afRequest
    }
    
    func cancelAllRequests() {
        
        self.manager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
    
    private func adapted(request: URLRequest, usingAdapters adapters: [RequestAdapter]?) -> URLRequest {
        
        var modifiedRequest = request
        
        adapters?.forEach {
            
            if let adaptedRequest = try? $0.adapt(modifiedRequest) {
                modifiedRequest = adaptedRequest
            }
        }
        
        return modifiedRequest
    }
}

