import Foundation
import RxSwift

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

        private let disposeBag: DisposeBag = DisposeBag()

        // MARK: -
        
        init(
            presenter: Presenter,
            itemsFetcher: ItemsWorker,
            sceneModel: Model.SceneModel
            ) {

            self.presenter = presenter
            self.itemsFetcher  = itemsFetcher
            self.sceneModel = sceneModel

            observeItems()
        }

        private func observeItems() {
            itemsFetcher
                .observeItems()
                .subscribe(onNext: { [weak self] (items) in
                    self?.sceneModel.items = items
                    self?.updateItems()
                })
                .disposed(by: disposeBag)

            itemsFetcher
                .observeLoadingStatus()
                .subscribe(onNext: { [weak self] (status) in
                    switch status {

                    case .idle:
                        let response = Listen.Event.DidEndFetching.Response()
                        self?.presenter.presentDidEndFetching(response: response)

                    case .loading:
                        let response = Listen.Event.DidStartFetching.Response()
                        self?.presenter.presentDidStartFetching(response: response)
                        
                    }
                })
                .disposed(by: disposeBag)
        }
    }
}

// MARK: - Private

private extension Listen.InteractorImp {

    func fetchItems() {
        itemsFetcher.fetchItems()
    }

    func updateItems() {
        presenter.presentItemsDidUpdate(response: Event.ItemsDidUpdate.Response(items: sceneModel.items))
    }
}

// MARK: - Interactor

extension Listen.InteractorImp: Listen.Interactor {

    func onViewDidLoad(request: Event.ViewDidLoad.Request) {
        presenter.presentViewDidLoad(response: Event.ViewDidLoad.Response(mode: sceneModel.mode))
        fetchItems()
    }

    func onDidSelectItem(request: Event.DidSelectItem.Request) {
        itemsFetcher.setItemToPlayer(request.itemId)
    }

    func onDidRemoveItem(request: Event.DidRemoveItem.Request) {
        itemsFetcher.removeItem(with: request.itemId)
    }

    func onDidPressSummary(request: Event.DidPressSummary.Request) {
        itemsFetcher.setItemToPlayer(request.itemId)
    }

    func onDidChangeEditing(request: Event.DidChangeEditing.Request) {
        sceneModel.isEditing = !sceneModel.isEditing
        presenter.presentDidChangeEditing(response: Listen.Event.DidChangeEditing.Response.init(isEditing: sceneModel.isEditing))
    }

    func onDidRefreshItems(request: Event.DidRefreshItems.Request) {
        fetchItems()
    }
}
