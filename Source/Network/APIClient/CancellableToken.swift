//
//  CancellableToken.swift
//  Scout
//
//

import Foundation
import Moya

// MARK: CancellableToken -

protocol CancellableToken {

    var isCancelled: Bool { get }

    func cancel()
}

// MARK: - MoyaCancellableToken -

public class MoyaCancellableToken {

    private var cancellable: Cancellable

    init(cancellable: Cancellable) {

        self.cancellable = cancellable
    }
}

extension MoyaCancellableToken: CancellableToken {
    
    public var isCancelled: Bool {
        return cancellable.isCancelled
    }

    public func cancel() {
        cancellable.cancel()
    }
}

// MARK: - EmptyCancellableToken -

public class EmptyCancellableToken: CancellableToken {

    var isCancelled: Bool {
        return true
    }

    func cancel() { }
}
