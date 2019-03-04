import Foundation

// MARK: - Protocol

protocol ListenInteractor: class {
    typealias Event = Listen.Event
    
    func onViewDidLoad(request: Event.ViewDidLoad.Request)
    func onDidSelectItem(request: Event.DidSelectItem.Request)
    func onDidRemoveItem(request: Event.DidRemoveItem.Request)
    func onDidPressSummary(request: Event.DidPressSummary.Request)
    func onDidChangeEditing(request: Event.DidChangeEditing.Request)
    func onDidRefreshItems(request: Event.DidRefreshItems.Request)
}

extension Listen {
    typealias Interactor = ListenInteractor

    // MARK: - Declaration

    class InteractorImp {

        typealias Model = Listen.Model
        typealias Event = Listen.Event

        // MARK: - Private properties
        
        private let presenter: Presenter
        private let itemsFetcher: ItemsWorker
        private var sceneModel: Model.SceneModel

        // MARK: -
        
        init(presenter: Presenter, itemsFetcher: ItemsWorker) {
            self.presenter = presenter
            self.itemsFetcher  = itemsFetcher

            sceneModel = Model.SceneModel(
                items: [],
                isEditing: false
            )
        }
    }
}

// MARK: - Private

private extension Listen.InteractorImp {

    func fetchItems() {
        itemsFetcher.fetchItems { [weak self] (result) in
            switch result {
            case .success(let items):
                self?.sceneModel.items = items
                self?.updateItems()
            case .failure:
                // FIXME: - Handle error
                return
            }
        }
    }

    func updateItems() {
        presenter.presentItemsDidUpdate(response: Event.ItemsDidUpdate.Response(items: sceneModel.items))
    }
}

// MARK: - Interactor

extension Listen.InteractorImp: Listen.Interactor {

    func onViewDidLoad(request: Event.ViewDidLoad.Request) {
        presenter.presentViewDidLoad(response: Event.ViewDidLoad.Response())
        fetchItems()
    }

    func onDidSelectItem(request: Event.DidSelectItem.Request) {

    }

    func onDidRemoveItem(request: Event.DidRemoveItem.Request) {
        sceneModel.items.removeAll { request.itemId == $0.itemId }
        itemsFetcher.removeItem(with: request.itemId) { (result) in
            // FIXME: - Handle result
        }

        updateItems()
    }

    func onDidPressSummary(request: Event.DidPressSummary.Request) {

    }

    func onDidChangeEditing(request: Event.DidChangeEditing.Request) {
        sceneModel.isEditing = !sceneModel.isEditing
        presenter.presentDidChangeEditing(response: Listen.Event.DidChangeEditing.Response.init(isEditing: sceneModel.isEditing))
    }

    func onDidRefreshItems(request: Event.DidRefreshItems.Request) {
        fetchItems()
    }
}
