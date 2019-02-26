import Foundation

// MARK: - Protocol
protocol OnboardingInteractor: class {

    // MARK: Typealiases

    typealias Event = Onboarding.Event

    // MARK: Requirements

    func onViewDidLoad(request: Event.ViewDidLoad.Request)
    func onSelectTopic(request: Event.DidSelectTopic.Request)
    func onStartButtonDidPress(request: Event.StartButtonDidPress.Request)
}

extension Onboarding {

    typealias Interactor = OnboardingInteractor

    // MARK: - Declaration
    class InteractorImp {

        typealias Model = Onboarding.Model
        typealias Event = Onboarding.Event

        private let presenter: Presenter
        private var sceneModel: Model.SceneModel
        private var topicsFetcher: TopicsFetcher
        
        init(presenter: Presenter, topicsFetcher: TopicsFetcher) {
            self.presenter = presenter
            self.topicsFetcher = topicsFetcher
            self.sceneModel = Model.SceneModel(
                numberForSelect: 3,
                topics: [],
                subtopics: [],
                selectedTopicsIds: [],
                isStartEnabled: false
            )
        }
    }
}

// MARK: - Private
private extension Onboarding.InteractorImp {
    func fetchTopics() {
        topicsFetcher.fetchTopics { (result) in
            switch result {
            case .success(let topics):
                self.sceneModel.topics = topics
                self.topicsDidFetch()

            case .failure:
                // FIXME: - Handle error
                return
            }
        }
    }

    func fetchSubtopics(with topicId: String) {
        topicsFetcher.fetchSubtopics(with: topicId) { (result) in
            switch result {
            case .success(let topics):
                self.sceneModel.subtopics.append((topicId, topics))
                self.subtopicsDidFetch()

            case .failure:
                // FIXME: - Handle error
                return
            }
        }
    }

    func topicsDidFetch() {
        presenter.presentTopicsDidDownload(
            response: Event.TopicsDidDownload.Response(
                topics: sceneModel.topics,
                subtopics: sceneModel.subtopics,
                selectedTopicsIds: sceneModel.selectedTopicsIds
            )
        )
    }

    func subtopicsDidFetch() {
        presenter.presentSubtopicsDidDownload(
            response: Event.SubtopicsDidDownload.Response(
                topics: sceneModel.topics,
                subtopics: sceneModel.subtopics,
                selectedTopicsIds: sceneModel.selectedTopicsIds
            )
        )
    }
}

// MARK: - Interactor
extension Onboarding.InteractorImp: Onboarding.Interactor {

    func onViewDidLoad(request: Event.ViewDidLoad.Request) {
        presenter.presentViewDidLoad(response: Onboarding.Event.ViewDidLoad.Response(numberForSelect: sceneModel.numberForSelect))
        fetchTopics()
    }

    func onSelectTopic(request: Event.DidSelectTopic.Request) {
        if sceneModel.selectedTopicsIds.contains(request.topicId) {
            if sceneModel.topics.contains(where: { $0.id == request.topicId }) {
                if let (_, subtopics) = sceneModel.subtopics.first(where: { $0.topicId == request.topicId }) {
                    sceneModel.selectedTopicsIds.removeAll(where: { topicId in
                        subtopics.contains { topic in topic.id == topicId }
                    } )

                    sceneModel.subtopics.removeAll { $0.topicId == request.topicId }
                }
            }

            sceneModel.selectedTopicsIds.removeAll { $0 == request.topicId}
        } else {
            sceneModel.selectedTopicsIds.append(request.topicId)
            if sceneModel.topics.contains(where: { $0.id == request.topicId }) {
                fetchSubtopics(with: request.topicId)
            }
        }

        sceneModel.isStartEnabled = sceneModel.selectedTopicsIds.count >= sceneModel.numberForSelect

        presenter.presentSelectTopic(
            response: Event.DidSelectTopic.Response(
                topics: sceneModel.topics,
                subtopics: sceneModel.subtopics,
                selectedTopicsIds: sceneModel.selectedTopicsIds,
                isStartEnabled: sceneModel.isStartEnabled
            )
        )
    }

    func onStartButtonDidPress(request: Event.StartButtonDidPress.Request) {

    }
}
