import Foundation

// MARK: - Protocol

protocol RecognitionInteractor: class {
    typealias Event = Recognition.Event
    
    func onViewDidLoad(request: Event.ViewDidLoad.Request)
}

extension Recognition {
    typealias Interactor = RecognitionInteractor

    // MARK: - Declaration

    class InteractorImp {

        typealias Model = Recognition.Model
        typealias Event = Recognition.Event

        // MARK: - Private properties
        
        private let presenter: Presenter

        // MARK: -
        
        init(presenter: Presenter) {
            self.presenter = presenter
        }
    }
}

//MARK: - Interactor

extension Recognition.InteractorImp: Recognition.Interactor {

    func onViewDidLoad(request: Event.ViewDidLoad.Request) {
        let response = Event.ViewDidLoad.Response()
        self.presenter.presentViewDidLoad(response: response)
    }
}
