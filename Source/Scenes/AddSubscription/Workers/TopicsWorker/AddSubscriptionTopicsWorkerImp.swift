//
//  AddSubscriptionTopicsWorkerImp.swift
//  Scout
//
//

import Foundation

class AddSubscriptionTopicsWorkerImp {

    let topicsApi: TopicsApi
    let queue: DispatchQueue

    init(topicsApi: TopicsApi, queue: DispatchQueue) {
        self.topicsApi = topicsApi
        self.queue = queue
    }
}

private extension AddSubscriptionTopicsWorkerImp {

    func addSubscriptionTopicFromTopic(_ topic: Topic) -> AddSubscription.Model.Topic {
        return AddSubscription.Model.Topic(
            topicId: topic.id,
            imageUrl: topic.imageUrl,
            title: topic.name
        )
    }
}

extension AddSubscriptionTopicsWorkerImp: AddSubscriptionTopicsWorker {

    func fetchTopics(completion: @escaping (Result) -> Void) {
        let dispatchGroup = DispatchGroup()

        var subscribedTopics: [Topic]?
        var topicsList: [Topic]?

        dispatchGroup.enter()
        topicsApi.requestSubscribedTopicsList { (result) in
            switch result {
            case .success(let topics):
                subscribedTopics = topics
            case .failure:
                subscribedTopics = nil
            }

            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        topicsApi.requestTopicList { (result) in
            switch result {
            case .success(let topics):
                topicsList = topics
            case .failure:
                topicsList = nil
            }

            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: queue) { [weak self] in
            guard let strongSelf = self else { return }

            guard var subscribedTopics = subscribedTopics, var topicsList = topicsList else {
                completion(.failure)
                return
            }

            topicsList.removeAll(where: { (topic) -> Bool in
                return subscribedTopics.contains(where: { (subscribedTopic) -> Bool in
                    return subscribedTopic.id == topic.id
                })
            })

            subscribedTopics.insert(
                Topic(
                    id: "top_100_podcasts",
                    name: "Top 100 Podcasts",
                    imageUrl: ""
                ),
                at: 0
            )

            let response = [
                AddSubscription.Model.Section(category: .like, topics: subscribedTopics.map { strongSelf.addSubscriptionTopicFromTopic($0) }),
                AddSubscription.Model.Section(category: .more, topics: topicsList.map { strongSelf.addSubscriptionTopicFromTopic($0) })
            ]

            completion(.success(response: response))
        }
    }
}
