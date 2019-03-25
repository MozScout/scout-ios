//
//  ApiClient.swift
//  Scout
//
//

import Foundation
import Moya

enum CommonError: Error {
    case unknown
    case requestWasCancelled
    case noInternetConnection
}

class ApiClient {

    let reachabilityService: ApiClientReachabilityServiceProtocol

    init(reachabilityService: ApiClientReachabilityServiceProtocol) {

        self.reachabilityService = reachabilityService
    }

    @discardableResult
    func requestObject<Target: TargetType, Response: Decodable>(
        target: Target,
        responseType T: Response.Type,
        callbackQueue: DispatchQueue?,
        success successCallback: @escaping (Response) -> Void,
        error errorCallback: @escaping (Error) -> Void
        ) -> Scout.CancellableToken {

        return request(
            target: target,
            callbackQueue: callbackQueue,
            success: { (data) in
                do {
                    successCallback(try Response.decode(from: data))
                } catch let error {
                    errorCallback(error)
                }
        },
            error: errorCallback
        )
    }

    @discardableResult
    func requestEmpty<Target: TargetType>(
        target: Target,
        callbackQueue: DispatchQueue?,
        success successCallback: @escaping () -> Void,
        error errorCallback: @escaping (Error) -> Void
        ) -> Scout.CancellableToken {

        return request(
            target: target,
            callbackQueue: callbackQueue,
            success: { (data) in
                successCallback()
        },
            error: errorCallback
        )
    }

    @discardableResult
    func requestData<Target: TargetType>(
        target: Target,
        callbackQueue: DispatchQueue?,
        success successCallback: @escaping (Data) -> Void,
        error errorCallback: @escaping (Error) -> Void
        ) -> Scout.CancellableToken {

        return request(
            target: target,
            callbackQueue: callbackQueue,
            success: { (data) in
                successCallback(data)
        },
            error: errorCallback
        )
    }

    // MARK: - Private methods

    private func request<Target: TargetType>(
        target: Target,
        callbackQueue: DispatchQueue?,
        success successCallback: @escaping (Data) -> Void,
        error errorCallback: @escaping (Error) -> Void
        ) -> Scout.CancellableToken {

        if !reachabilityService.isReachable {
            errorCallback(CommonError.noInternetConnection)
            return EmptyCancellableToken()
        }

        let cancellable = NetworkAdapter.request(
            target: target,
            callbackQueue: callbackQueue
        ) { [weak self] (result) in

            switch result {

            case .success(let response):
                if 200..<400 ~= response.statusCode {
                    successCallback(response.data)
                    return
                }
                
            case .failure(let error):
                if let error = self?.errorFromMoyaError(error) {
                    errorCallback(error)
                    return
                }
            }

            errorCallback(CommonError.unknown)
        }
        return MoyaCancellableToken(cancellable: cancellable)
    }
    
    private func errorFromMoyaError(_ error: MoyaError) -> NSError? {
        switch error {

        case .underlying(let error, _):
            return error as NSError

        default:
            break
        }
        
        return nil
    }
}
