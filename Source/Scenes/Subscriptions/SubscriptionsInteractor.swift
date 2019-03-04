import Foundation

// MARK: - Protocol

protocol SubscriptionsInteractor: class {
    typealias Event = Subscriptions.Event
    
    func onViewDidLoad(request: Event.ViewDidLoad.Request)
}

extension Subscriptions {
    typealias Interactor = SubscriptionsInteractor

    // MARK: - Declaration

    class InteractorImp {

        typealias Model = Subscriptions.Model
        typealias Event = Subscriptions.Event

        // MARK: - Private properties
        
        private let presenter: Presenter

        // MARK: -
        
        init(presenter: Presenter) {
            self.presenter = presenter
        }
    }
}

//MARK: - Interactor

extension Subscriptions.InteractorImp: Subscriptions.Interactor {

    func onViewDidLoad(request: Event.ViewDidLoad.Request) {
        let response = Event.ViewDidLoad.Response()
        self.presenter.presentViewDidLoad(response: response)
    }
}
