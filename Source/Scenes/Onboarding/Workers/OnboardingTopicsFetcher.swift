//
//  OnboardingTopicsFetcher.swift
//  Scout
//
//

import Foundation

protocol OnboardingTopicsFetcher {

    typealias TopicsFetcherResult = Onboarding.TopicsFetcherResult

    func fetchTopics(completion: @escaping (TopicsFetcherResult) -> Void)
    func fetchSubtopics(with topicId: String, completion: @escaping (TopicsFetcherResult) -> Void) -> CancellableToken
}

extension Onboarding {

    typealias TopicsFetcher = OnboardingTopicsFetcher

    enum TopicsFetcherResult {
        case success([Topic])
        case failure
    }

    class TopicsFetcherImp {
        
        let topicsApi: TopicsApi

        init(topicsApi: TopicsApi) {
            self.topicsApi = topicsApi
        }
    }
}

extension Onboarding.TopicsFetcherImp: Onboarding.TopicsFetcher {

    func fetchTopics(completion: @escaping (TopicsFetcherResult) -> Void) {
        topicsApi.requestTopicList { (result) in
            switch result {
            case .success(let topics):
                completion(.success(topics))
            case .failure:
                completion(.failure)
            }
        }
    }

    func fetchSubtopics(with topicId: String, completion: @escaping (TopicsFetcherResult) -> Void) -> CancellableToken {
        return topicsApi.requestSubtopicList(with: SubtopicListRequestParameters(id: topicId)) { (result) in
            switch result {
            case .success(let topics):
                completion(.success(topics))
            case .failure:
                completion(.failure)
            }
        }
    }
}
