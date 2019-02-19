//
//  ReachabilityService.swift
//  Scout
//
//

import Foundation
import Reachability

class ReachabilityService {

    private let reachability: Reachability?
    
    init() {
        self.reachability = Reachability()

        if self.reachability == nil {
            print(.fatalError(error: "Cannot instantiate reachability"))
        }

        resume()
    }
    
    func resume() {
        do {
            try self.reachability?.startNotifier()
        } catch {
            print(.error(error: "Cannot start reachability notifier"))
        }
    }
    
    var isNetworkAvailable : Bool {
        return self.reachabilityStatus != .none
    }
    
    var isWifiAvailable : Bool {
        return self.reachabilityStatus == .wifi
    }
    
    private var reachabilityStatus: Reachability.Connection? {
        return self.reachability?.connection
    }

    func pause() {
        self.reachability?.stopNotifier()
    }
}
