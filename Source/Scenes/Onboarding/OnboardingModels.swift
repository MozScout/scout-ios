import Foundation

// MARK: - Namespace
enum Onboarding {

    // MARK: Typealiases

    typealias InteractorDispatcher = Dispatcher<Interactor>
    typealias PresenterDispatcher<Type: ViewController> = Dispatcher<Weak<Type>>
    typealias ViewController = OnboardingViewController
    typealias ViewControllerImp = OnboardingViewControllerImp

    // MARK: Subspaces

    enum Model {}
    enum Event {}
}

// MARK: - Models
extension Onboarding.Model {

    struct SceneModel {

        let numberForSelect: Int
        var topics: [Topic]
        var subtopics: [(topicId: String, subtopics: [Topic])]
        var selectedTopicsIds: [String]
        var isStartEnabled: Bool
    }
}

// MARK: - Events
extension Onboarding.Event {
    
    typealias Model = Onboarding.Model

    enum ViewDidLoad {

        struct Request {}
        struct Response {
            let numberForSelect: Int
        }

        struct ViewModel {
            let headerTitle: String
            let buttonTitle: String
        }
    }

    enum SubtopicsDidDownload {

        struct Response {
            let topics: [Topic]
            let subtopics: [(topicId: String, subtopics: [Topic])]
            let selectedTopicsIds: [String]
        }

        struct ViewModel {
            let topics: [OnboardingCollectionViewCell.ViewModel]
        }
    }

    enum TopicsDidDownload {

        struct Response {
            let topics: [Topic]
            let subtopics: [(topicId: String, subtopics: [Topic])]
            let selectedTopicsIds: [String]
        }

        struct ViewModel {
            let topics: [OnboardingCollectionViewCell.ViewModel]
        }
    }
    
    enum DidSelectTopic {

        struct Request {
            let topicId: String
        }

        struct Response {
            let topics: [Topic]
            let subtopics: [(topicId: String, subtopics: [Topic])]
            let selectedTopicsIds: [String]
            let isStartEnabled: Bool
        }

        struct ViewModel {
            let topics: [OnboardingCollectionViewCell.ViewModel]
            let isStartEnabled: Bool
        }
    }

    enum StartButtonDidPress {

        struct Request {
        }

        struct Response {
        }

        struct ViewModel {
        }
    }
}
