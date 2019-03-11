//
//  AddSubscriptionTopicsWorker.swift
//  Scout
//
//

import Foundation

enum AddSubscriptionTopicsWorkerResult {
    case success(response: [AddSubscription.Model.Section])
    case failure
}

protocol AddSubscriptionTopicsWorker {

    typealias Result = AddSubscriptionTopicsWorkerResult

    func fetchTopics(completion: @escaping (Result) -> Void)
}
