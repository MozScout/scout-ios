//
//  ScoutHTTPClient.swift
//  Scout
//
//

import Alamofire
import Foundation

protocol NetworkClientObserverProtocol: class {

}

protocol NetworkClientObserverSubscriptionProtocol: class {

    func subscribeForNetworkClientChanges(observer: NetworkClientObserverProtocol)
    func unsubscribeFromNetworkClientChanges(observer: NetworkClientObserverProtocol)
}

class ScoutHTTPClient: BaseHTTPClient {

    var mapper: NetworkMappingProtocol
    var requestBuilder: NetworkRequestBuilderProtocol

    fileprivate let observers: WeakPointerArray<NetworkClientObserverProtocol>!

    required init(with mapper: NetworkMappingProtocol,
                  requestBuilder: NetworkRequestBuilderProtocol,
                  manager: SessionManager,
                  adapters: [RequestAdapter]? = nil) {

        self.mapper = mapper
        self.requestBuilder = requestBuilder
        self.observers = WeakPointerArray<NetworkClientObserverProtocol>()

        super.init(withManager: manager, adapters: adapters)
    }
}

// MARK: -
// MARK: NetworkClientObserverSubscriptionProtocol
extension ScoutHTTPClient: NetworkClientObserverSubscriptionProtocol {

    func subscribeForNetworkClientChanges(observer: NetworkClientObserverProtocol) {
        observers.add(observer)
    }

    func unsubscribeFromNetworkClientChanges(observer: NetworkClientObserverProtocol) {
        observers.remove(observer)
    }
}
