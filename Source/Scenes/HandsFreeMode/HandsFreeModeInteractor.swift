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
        private let handsFreeService: HandsFreeService
        private var sceneModel: Model.SceneModel

        // MARK: -
        
        init(presenter: Presenter, handsFreeService: HandsFreeService) {
            self.presenter = presenter
            self.handsFreeService = handsFreeService

            sceneModel = Model.SceneModel(isHandsFreeModeEnabled: handsFreeService.isDetecting)
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
        if sceneModel.isHandsFreeModeEnabled {
            handsFreeService.startDetecting()
        } else {
            handsFreeService.stopDetecting()
        }

        let response = Event.ModeDidSwitched.Response(isHandsFreeModeEnabled: sceneModel.isHandsFreeModeEnabled)
        self.presenter.presentModeDidSwitched(response: response)
    }
}
