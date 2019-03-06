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
        }) { (_) in
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
        with requestParameters: SubtopicListRequestParameters,
        completion: @escaping (RequestSubtopicListResult) -> Void
        ) -> CancellableToken {

        let target = TopicsTarget(
            baseURL: baseUrl,
            request: .subtopicList(requestParameters)
        )

        return apiClient.requestObject(
            target: target,
            responseType: [Topic].self,
            callbackQueue: nil,
            success: { (topics) in
                completion(.success(topics))
        }) { (_) in
            completion(.failure)
        }
    }

    // MARK: - Request subscribed topics list -

    enum RequestSubscribedTopicsListResult {
        case success([Topic])
        case failure
    }

    @discardableResult
    func requestSubscribedTopicsList(
        completion: @escaping (RequestSubscribedTopicsListResult) -> Void
        ) -> CancellableToken {

        let target = TopicsTarget(
            baseURL: baseUrl,
            request: .subscribedTopicsList
        )

        return apiClient.requestObject(
            target: target,
            responseType: [Topic].self,
            callbackQueue: nil,
            success: { (topics) in
                completion(.success(topics))
        }) { (_) in
            completion(.failure)
        }
    }

}
