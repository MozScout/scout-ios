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
        
        init(presenter: Presenter) {
            self.presenter = presenter
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
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.2) {
            self.sceneModel.topics = [
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Lorem ipsum dolor", imageUrl: "https://www.elastic.co/assets/bltada7771f270d08f6/enhanced-buzz-1492-1379411828-15.jpg"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Sit amet, consectetur", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsgKWaWvMfgSmQjJBETlectexGQ4qM_Yf4eiP44iWKUqBASfGvUA"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Adipiscing elit", imageUrl: "https://resize.indiatvnews.com/en/centered/newbucket/715_431/2018/03/h6-1521531233.jpg"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Sed do eiusmod", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS56K-U4En-hLXTl1y1ZLG0aZ4ZaiJagJtkkHv1FA4kjst1k-iKgw"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Tempor incididunt", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKh5lAmjMOOXur3afxuBWCUtn9z8uNW3SH8EEmgPs0ANUikfaD"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Dolore magna aliqua", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1ouJRTKivYp-IJF905P_GFgi7HU6Kt9qbDrSkPxCUZEbizo_Xyg"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Lorem ipsum dolor", imageUrl: "https://www.elastic.co/assets/bltada7771f270d08f6/enhanced-buzz-1492-1379411828-15.jpg"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Sit amet, consectetur", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsgKWaWvMfgSmQjJBETlectexGQ4qM_Yf4eiP44iWKUqBASfGvUA"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Adipiscing elit", imageUrl: "https://resize.indiatvnews.com/en/centered/newbucket/715_431/2018/03/h6-1521531233.jpg"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Sed do eiusmod", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS56K-U4En-hLXTl1y1ZLG0aZ4ZaiJagJtkkHv1FA4kjst1k-iKgw"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Tempor incididunt", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKh5lAmjMOOXur3afxuBWCUtn9z8uNW3SH8EEmgPs0ANUikfaD"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Dolore magna aliqua", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1ouJRTKivYp-IJF905P_GFgi7HU6Kt9qbDrSkPxCUZEbizo_Xyg"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Lorem ipsum dolor", imageUrl: "https://www.elastic.co/assets/bltada7771f270d08f6/enhanced-buzz-1492-1379411828-15.jpg"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Sit amet, consectetur", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsgKWaWvMfgSmQjJBETlectexGQ4qM_Yf4eiP44iWKUqBASfGvUA"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Adipiscing elit", imageUrl: "https://resize.indiatvnews.com/en/centered/newbucket/715_431/2018/03/h6-1521531233.jpg"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Sed do eiusmod", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS56K-U4En-hLXTl1y1ZLG0aZ4ZaiJagJtkkHv1FA4kjst1k-iKgw"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Tempor incididunt", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKh5lAmjMOOXur3afxuBWCUtn9z8uNW3SH8EEmgPs0ANUikfaD"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Dolore magna aliqua", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1ouJRTKivYp-IJF905P_GFgi7HU6Kt9qbDrSkPxCUZEbizo_Xyg"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Lorem ipsum dolor", imageUrl: "https://www.elastic.co/assets/bltada7771f270d08f6/enhanced-buzz-1492-1379411828-15.jpg"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Sit amet, consectetur", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsgKWaWvMfgSmQjJBETlectexGQ4qM_Yf4eiP44iWKUqBASfGvUA"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Adipiscing elit", imageUrl: "https://resize.indiatvnews.com/en/centered/newbucket/715_431/2018/03/h6-1521531233.jpg"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Sed do eiusmod", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS56K-U4En-hLXTl1y1ZLG0aZ4ZaiJagJtkkHv1FA4kjst1k-iKgw"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Tempor incididunt", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKh5lAmjMOOXur3afxuBWCUtn9z8uNW3SH8EEmgPs0ANUikfaD")
            ].shuffled()

            self.topicsDidFetch()
        }
    }

    func fetchSubtopics(with topicId: String) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.2) {
            self.sceneModel.subtopics.append((topicId: topicId, subtopics: [
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Ut enim ad", imageUrl: "http://www.thinkstockphotos.com/ts-resources/images/home/TS_AnonHP_462882495_01.jpg"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Minim veniam", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9_JWAFA_Q8kQitjXBwRtNUw5xOSKC_SF_rbZOTriNOMncfrM0Ww"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Quis nostrud exercitation", imageUrl: "https://cdn.cnn.com/cnnnext/dam/assets/190121090951-04-blood-moon-global-01212019-exlarge-169.jpg"),
                Topic(id: UInt.random(in: UInt.min...UInt.max).description, name: "Ullamco laboris", imageUrl: "https://media.mnn.com/assets/images/2016/11/closeup-baby-robin-beak-open.jpg.653x0_q80_crop-smart.jpg")
                ].shuffled()))

            self.subtopicsDidFetch()
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
