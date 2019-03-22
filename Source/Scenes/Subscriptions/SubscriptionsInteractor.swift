import Foundation

// MARK: - Protocol

protocol SubscriptionsInteractor: class {

    func onViewDidLoad(request: Subscriptions.Event.ViewDidLoad.Request)
    func onRefreshDidStart(request: Subscriptions.Event.RefreshDidStart.Request)
}

extension Subscriptions {
    typealias Interactor = SubscriptionsInteractor

    // MARK: - Declaration

    class InteractorImp {

        typealias Model = Subscriptions.Model
        typealias Event = Subscriptions.Event

        // MARK: - Private properties
        
        private let presenter: Presenter
        private var sceneModel: Model.SceneModel

        // MARK: -
        
        init(presenter: Presenter) {
            self.presenter = presenter

            sceneModel = Model.SceneModel(
                sections: []
            )
        }

        private func displaySectionsDidUpdate() {
            let response = Event.SectionsDidUpdate.Response(sections: sceneModel.sections)
            presenter.presentSectionsDidUpdate(response: response)
        }

        private func displayRefreshDidFinish() {
            let response = Event.RefreshDidFinish.Response()
            presenter.presentRefreshDidFinish(response: response)
        }
    }
}

//MARK: - Interactor

extension Subscriptions.InteractorImp: Subscriptions.Interactor {

    func onViewDidLoad(request: Subscriptions.Event.ViewDidLoad.Request) {
        let response = Event.ViewDidLoad.Response()
        self.presenter.presentViewDidLoad(response: response)

        displaySectionsDidUpdate()
    }

    func onRefreshDidStart(request: Subscriptions.Event.RefreshDidStart.Request) {
        let firstUrl = URL(string: "https://www.kolesa.ru/uploads/2018/03/gaz_21_volga_5.jpg")!
        let secondUrl = URL(string: "https://a.d-cd.net/68afees-960.jpg")!
        sceneModel.sections = [
            Model.Section(title: "First title", items: [
                Model.Item(iconUrl: firstUrl, title: "First", date: Date()),
                Model.Item(iconUrl: secondUrl, title: "Second", date: Date()),
                Model.Item(iconUrl: firstUrl, title: "Third", date: Date()),
                Model.Item(iconUrl: secondUrl, title: "Fourth", date: Date()),
                Model.Item(iconUrl: firstUrl, title: "Fiveth", date: Date()),
                Model.Item(iconUrl: secondUrl, title: "Sixth", date: Date()),
                Model.Item(iconUrl: firstUrl, title: "First", date: Date()),
                Model.Item(iconUrl: secondUrl, title: "Second", date: Date()),
                Model.Item(iconUrl: firstUrl, title: "Third", date: Date()),
                Model.Item(iconUrl: secondUrl, title: "Fourth", date: Date()),
                Model.Item(iconUrl: firstUrl, title: "Fiveth", date: Date()),
                Model.Item(iconUrl: secondUrl, title: "Sixth", date: Date()),
                Model.Item(iconUrl: secondUrl, title: "Seventh\nMultiline\nKext", date: Date())
                ]),
            Model.Section(title: "Second title", items: [
                Model.Item(iconUrl: secondUrl, title: "First", date: Date()),
                Model.Item(iconUrl: firstUrl, title: "Second", date: Date()),
                Model.Item(iconUrl: secondUrl, title: "Third\nMultiline", date: Date()),
                Model.Item(iconUrl: firstUrl, title: "Eleventh", date: Date()),
                Model.Item(iconUrl: secondUrl, title: "Twelveth", date: Date())
                ]),
            Model.Section(title: "Third title", items: [
                Model.Item(iconUrl: firstUrl, title: "Third", date: Date()),
                Model.Item(iconUrl: secondUrl, title: "Second", date: Date())
                ]),
            Model.Section(title: "Fourth title", items: [
                Model.Item(iconUrl: firstUrl, title: "Third", date: Date()),
                Model.Item(iconUrl: secondUrl, title: "Second", date: Date())
                ]),
            Model.Section(title: "Fiveth title", items: [
                Model.Item(iconUrl: firstUrl, title: "Third", date: Date()),
                Model.Item(iconUrl: secondUrl, title: "Second\nAnother one", date: Date())
                ]),
            Model.Section(title: "Sixth title", items: [
                Model.Item(iconUrl: firstUrl, title: "Third", date: Date()),
                Model.Item(iconUrl: secondUrl, title: "Second", date: Date())
                ])
        ]
        displaySectionsDidUpdate()
        displayRefreshDidFinish()
    }
}
