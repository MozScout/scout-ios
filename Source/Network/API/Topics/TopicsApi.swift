//
//  TopicsAPI.swift
//  Scout
//
//

import Foundation

class TopicsApi: BaseApi {

    // MARK: - Request topic list -

    enum RequestTopicListResult {
        case success([Topic])
        case failure
    }

    @discardableResult
    func requestTopicList(
        completion: @escaping (RequestTopicListResult) -> Void
        ) -> CancellableToken {

        let target = TopicsTarget(
            baseURL: baseUrl,
            request: .topicList
        )

        return apiClient.requestObject(
            target: target,
            responseType: [Topic].self,
            callbackQueue: nil,
            success: { (topics) in
                completion(.success(topics))
        }) {
            completion(.failure)
        }
    }

    // MARK: - Request subtopic list -

    enum RequestSubtopicListResult {
        case success([Topic])
        case failure
    }

    @discardableResult
    func requestSubtopicList(
        for topicId: Int64,
        completion: @escaping (RequestSubtopicListResult) -> Void
        ) -> CancellableToken {

        let target = TopicsTarget(
            baseURL: baseUrl,
            request: .subtopicList(topicId: topicId)
        )

        return apiClient.requestObject(
            target: target,
            responseType: [Topic].self,
            callbackQueue: nil,
            success: { (topics) in
                completion(.success(topics))
        }) {
            completion(.failure)
        }
    }
}
