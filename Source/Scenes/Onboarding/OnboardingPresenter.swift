import Foundation

// MARK: - Protocol
protocol OnboardingPresenter {

    // MARK: Typealiases

    typealias Event = Onboarding.Event

    // MARK: Requirements

    func presentViewDidLoad(response: Event.ViewDidLoad.Response)
    func presentSelectTopic(response: Event.DidSelectTopic.Response)
    func presentTopicsDidDownload(response: Event.TopicsDidDownload.Response)
    func presentSubtopicsDidDownload(response: Event.SubtopicsDidDownload.Response)
    func presentDidRegisterUser(response: Event.DidRegisterUser.Response)
    func presentRegistrationProcessDidStart(response: Event.RegistrationProcessDidStart.Response)
    func presentRegistrationProcessDidEnd(response: Event.RegistrationProcessDidEnd.Response)
}

extension Onboarding {

    typealias Presenter = OnboardingPresenter

    // MARK: - Declaration
    class PresenterImp<Type: ViewController> {

        typealias Model = Onboarding.Model
        typealias Event = Onboarding.Event


        private let presenterDispatcher: PresenterDispatcher<Type>

        init(presenterDispatcher: PresenterDispatcher<Type>) {
            self.presenterDispatcher = presenterDispatcher
        }
    }
}

// MARK: - Private
extension Onboarding.PresenterImp {
    func makeTopicsViewModels(
        topics: [Topic],
        subtopics: [(topicId: String, subtopics: [Topic])],
        selectedTopicsIds: [String]
        ) -> [OnboardingCollectionViewCell.ViewModel] {

        var topicsViewModels = [OnboardingCollectionViewCell.ViewModel]()

        for topic in topics {
            topicsViewModels.append(
                OnboardingCollectionViewCell.ViewModel(
                    topicId: topic.id,
                    title: topic.name,
                    imageUrl: URL(string: topic.imageUrl),
                    isSelected: selectedTopicsIds.contains(topic.id)
                )
            )

            if let (_, subtopics) = subtopics.first(where: { $0.topicId == topic.id }) {
                for subtopic in subtopics {
                    topicsViewModels.append(
                        OnboardingCollectionViewCell.ViewModel(
                            topicId: subtopic.id,
                            title: subtopic.name,
                            imageUrl: URL(string: subtopic.imageUrl),
                            isSelected: selectedTopicsIds.contains(subtopic.id)
                        )
                    )
                }
            }
        }

        return topicsViewModels
    }
}

// MARK: - Presenter
extension Onboarding.PresenterImp: Onboarding.Presenter {

    func presentViewDidLoad(response: Event.ViewDidLoad.Response) {
        let viewModel = Event.ViewDidLoad.ViewModel(
            headerTitle: "Choose \(response.numberForSelect) or more topics of interest.",
            buttonTitle: "Get Started"
        )

        self.presenterDispatcher.async { (viewController) in
            viewController.obj?.displayViewDidLoad(viewModel: viewModel)
        }
    }

    func presentSelectTopic(response: Event.DidSelectTopic.Response) {
        let topicsViewModels = makeTopicsViewModels(
            topics: response.topics,
            subtopics: response.subtopics,
            selectedTopicsIds: response.selectedTopicsIds
        )

        let viewModel = Event.DidSelectTopic.ViewModel.init(
            topics: topicsViewModels,
            isStartEnabled: response.isStartEnabled
        )

        presenterDispatcher.async { (viewController) in
            viewController.obj?.displayDidSelectTopic(viewModel: viewModel)
        }
    }

    func presentTopicsDidDownload(response: Event.TopicsDidDownload.Response) {
        let topicsViewModels = makeTopicsViewModels(
            topics: response.topics,
            subtopics: response.subtopics,
            selectedTopicsIds: response.selectedTopicsIds
        )

        let viewModel = Event.TopicsDidDownload.ViewModel(topics: topicsViewModels)

        presenterDispatcher.async { (viewController) in
            viewController.obj?.displayTopicsDidDownload(viewModel: viewModel)
        }
    }

    func presentSubtopicsDidDownload(response: Event.SubtopicsDidDownload.Response) {
        let topicsViewModels = makeTopicsViewModels(
            topics: response.topics,
            subtopics: response.subtopics,
            selectedTopicsIds: response.selectedTopicsIds
        )

        let viewModel = Event.SubtopicsDidDownload.ViewModel(topics: topicsViewModels)

        presenterDispatcher.async { (viewController) in
            viewController.obj?.displaySubtopicsDidDownload(viewModel: viewModel)
        }
    }

    func presentDidRegisterUser(response: Event.DidRegisterUser.Response) {
        let viewModel = response

        presenterDispatcher.async { (viewController) in
            viewController.obj?.displayDidRegisterUser(viewModel: viewModel)
        }
    }

    func presentRegistrationProcessDidStart(response: Event.RegistrationProcessDidStart.Response) {
        let viewModel = Event.RegistrationProcessDidStart.ViewModel()

        presenterDispatcher.async { (viewController) in
            viewController.obj?.displayRegistrationProcessDidStart(viewModel: viewModel)
        }
    }

    func presentRegistrationProcessDidEnd(response: Event.RegistrationProcessDidEnd.Response) {
        let viewModel = Event.RegistrationProcessDidEnd.ViewModel()

        presenterDispatcher.async { (viewController) in
            viewController.obj?.displayRegistrationProcessDidEnd(viewModel: viewModel)
        }
    }
}
