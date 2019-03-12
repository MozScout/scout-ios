//
//  PlayerItemProviderImp.swift
//  Scout
//
//

import Foundation
import RxSwift
import RxCocoa

extension Player {

    class ItemProviderImp {

        private let itemsProvider: PlayerItemsProvider
        private let audioLoader: PlayerAudioLoader

        private let itemBehaviorRelay: BehaviorRelay<Player.Model.Item?> = BehaviorRelay(value: nil)

        private let disposeBag: DisposeBag = DisposeBag()

        init(
            itemsProvider: PlayerItemsProvider,
            audioLoader: PlayerAudioLoader
            ) {

            self.itemsProvider = itemsProvider
            self.audioLoader = audioLoader

            observeItemsProvider()
        }

        private func observeItemsProvider() {

            itemsProvider
                .observeSelectedItemIdentifier()
                .subscribe(onNext: { [weak self] (id) in
                    self?.selectedItemIdentifierDidChange(id)
                })
                .disposed(by: disposeBag)
        }

        private func selectedItemIdentifierDidChange(_ id: PlayerItemIdentifier?) {
            guard let id = itemsProvider.selectedItemId,
                let item = itemsProvider.item(for: id)
                else {

                    return
            }

            switch item.type {
            case .article(let url):
                audioLoader.loadArticle(for: url) { [weak self] (result) in
                    self?.loadArticleCompletion(result)
                }

            case .episode:
                print(.fatalError(error: "Episodes are not handled"))
                break
            }
        }

        private func loadArticleCompletion(_ result: PlayerAudioLoader.LoadArticleResult) {
            switch result {
                
            case .success(let response):
                itemBehaviorRelay.accept(item(from: response))

            case .failure:
                break
            }
        }

        private func item(from response: ArticleResponse) -> Player.Model.Item {
            return Player.Model.Item(
                title: response.title,
                author: response.author,
                lengthMinutes: response.lengthMinutes,
                audioUrl: response.audioUrl,
                imageUrl: response.imageUrl,
                publisher: response.publisher,
                excerpt: response.excerpt,
                iconUrl: response.iconUrl
            )
        }
    }
}

extension Player.ItemProviderImp: Player.ItemProvider {

    func observeItem() -> Observable<Player.Model.Item?> {
        return itemBehaviorRelay.asObservable()
    }
}
