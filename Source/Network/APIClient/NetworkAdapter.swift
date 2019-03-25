//
//  NetworkAdapter.swift
//  Scout
//
//

import Foundation
import Moya

enum NetworkAdapter {
    
    static private let networkAdapterQueue: DispatchQueue = DispatchQueue(
        label: "networkAdapterQueue",
        qos: .utility,
        attributes: .concurrent
    )
    
    static func request<T: TargetType>(
        target: T,
        callbackQueue: DispatchQueue? = nil,
        callback: @escaping Moya.Completion
        ) -> Cancellable {

        let provider: MoyaProvider = MoyaProvider<T>()
        return provider.request(
            target,
            callbackQueue: callbackQueue ?? networkAdapterQueue,
            progress: nil
        ) { (result) in
            callback(result)
        }
    }
}
