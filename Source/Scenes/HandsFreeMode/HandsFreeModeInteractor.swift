import Foundation

// MARK: - Protocol

protocol HandsFreeModeInteractor: class {
    typealias Event = HandsFreeMode.Event
    
    func onViewDidLoad(request: Event.ViewDidLoad.Request)
    func onModeDidSwitched(request: Event.ModeDidSwitched.Request)
}

extension HandsFreeMode {
    typealias Interactor = HandsFreeModeInteractor

    // MARK: - Declaration

    class InteractorImp {

        typealias Model = HandsFreeMode.Model
        typealias Event = HandsFreeMode.Event

        // MARK: - Private properties
        
        private let presenter: Presenter
        private var sceneModel: Model.SceneModel

        // MARK: -
        
        init(presenter: Presenter) {
            self.presenter = presenter

            sceneModel = Model.SceneModel(isHandsFreeModeEnabled: false)
        }
    }
}

//MARK: - Interactor

extension HandsFreeMode.InteractorImp: HandsFreeMode.Interactor {

    func onViewDidLoad(request: Event.ViewDidLoad.Request) {
        let response = Event.ViewDidLoad.Response(isHandsFreeModeEnabled: sceneModel.isHandsFreeModeEnabled)
        self.presenter.presentViewDidLoad(response: response)
    }

    func onModeDidSwitched(request: Event.ModeDidSwitched.Request) {
        sceneModel.isHandsFreeModeEnabled = !sceneModel.isHandsFreeModeEnabled

        let response = Event.ModeDidSwitched.Response(isHandsFreeModeEnabled: sceneModel.isHandsFreeModeEnabled)
        self.presenter.presentModeDidSwitched(response: response)
    }
}
