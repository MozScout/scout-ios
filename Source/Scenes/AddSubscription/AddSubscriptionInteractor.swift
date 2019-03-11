import Foundation

// MARK: - Protocol

protocol AddSubscriptionInteractor: class {
    typealias Event = AddSubscription.Event
    
    func onViewDidLoad(request: Event.ViewDidLoad.Request)
}

extension AddSubscription {
    typealias Interactor = AddSubscriptionInteractor

    // MARK: - Declaration

    class InteractorImp {

        typealias Model = AddSubscription.Model
        typealias Event = AddSubscription.Event

        // MARK: - Private properties

        private var sceneModel: Model.SceneModel
        private let presenter: Presenter
        private let topicsWorker: AddSubscriptionTopicsWorker

        // MARK: -
        
        init(presenter: Presenter, topicsWorker: AddSubscriptionTopicsWorker) {
            self.presenter = presenter
            self.topicsWorker = topicsWorker
            sceneModel = Model.SceneModel(items: [])
        }
    }
}

//MARK: - Interactor

extension AddSubscription.InteractorImp: AddSubscription.Interactor {

    func onViewDidLoad(request: Event.ViewDidLoad.Request) {
        let response = Event.ViewDidLoad.Response()
        presenter.presentViewDidLoad(response: response)
        presenter.presentDidStartFetching(response: Event.DidStartFetching.Response())

        topicsWorker.fetchTopics { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.sceneModel.items = response
                self?.presenter.presentTopicsDidUpdate(response: Event.TopicsDidUpdate.Response(items: response))
            case .failure:
                // FIXME - Handle error
                break
            }

            self?.presenter.presentDidEndFetching(response: Event.DidEndFetching.Response())
        }
    }
}
