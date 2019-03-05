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
        
        private let presenter: Presenter

        // MARK: -
        
        init(presenter: Presenter) {
            self.presenter = presenter
        }
    }
}

//MARK: - Interactor

extension AddSubscription.InteractorImp: AddSubscription.Interactor {

    func onViewDidLoad(request: Event.ViewDidLoad.Request) {
        let response = Event.ViewDidLoad.Response()
        self.presenter.presentViewDidLoad(response: response)
    }
}
