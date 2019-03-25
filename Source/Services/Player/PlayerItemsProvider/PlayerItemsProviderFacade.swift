//
//  PlayerItemsProviderFacade.swift
//  Scout
//
//

import Foundation
import RxSwift
import RxCocoa

class PlayerItemsProviderFacade {

    private var currentProvider: PlayerItemsProvider?
    private let selectedIdentifierBehaviorRelay: BehaviorRelay<PlayerItemIdentifier?> = BehaviorRelay(value: nil)

    private var selectedIdentifierDisposable: Disposable?

    func setSelectedItem(
        identifier: PlayerItemIdentifier,
        in provider: PlayerItemsProvider
        ) {

        currentProvider = provider
        selectItem(with: identifier)

        selectedIdentifierDisposable?.dispose()

        selectedIdentifierDisposable = provider
            .observeSelectedItemIdentifier()
            .subscribe(onNext: { [weak self] (identifier) in
                self?.selectedIdentifierBehaviorRelay.accept(identifier)
            })
    }
}

extension PlayerItemsProviderFacade: PlayerItemsProvider {

    func item(for id: PlayerItemIdentifier) -> PlayerItem? {
        return currentProvider?.item(for: id)
    }

    var items: [PlayerItem] {
        return currentProvider?.items ?? []
    }

    var selectedItemId: PlayerItemIdentifier? {
        return currentProvider?.selectedItemId
    }

    func selectItem(with id: PlayerItemIdentifier?) {
        currentProvider?.selectItem(with: id)
    }

    func observeSelectedItemIdentifier() -> Observable<PlayerItemIdentifier?> {
        return selectedIdentifierBehaviorRelay.asObservable()
    }
}
