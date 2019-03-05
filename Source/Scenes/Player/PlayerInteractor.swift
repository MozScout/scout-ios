import Foundation

// MARK: - Protocol

protocol PlayerInteractor: class {
    typealias Event = Player.Event
    
    func onViewDidLoad(request: Event.ViewDidLoad.Request)
}

extension Player {
    typealias Interactor = PlayerInteractor

    // MARK: - Declaration

    class InteractorImp {

        typealias Model = Player.Model
        typealias Event = Player.Event

        // MARK: - Private properties
        
        private let presenter: Presenter

        // MARK: -
        
        init(presenter: Presenter) {
            self.presenter = presenter
        }
    }
}

//MARK: - Interactor

extension Player.InteractorImp: Player.Interactor {

    func onViewDidLoad(request: Event.ViewDidLoad.Request) {
        let response = Event.ViewDidLoad.Response()
        self.presenter.presentViewDidLoad(response: response)
    }
}
