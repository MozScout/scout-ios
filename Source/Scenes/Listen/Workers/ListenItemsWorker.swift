//
//  ListenItemsWorker.swift
//  Scout
//
//

import Foundation

protocol ListenItemsWorker {

    typealias ItemsWorkerResult = Listen.ItemsWorkerResult

    func fetchItems(completion: @escaping (ItemsWorkerResult) -> Void)
    func removeItem(with itemId: String, completion:  @escaping (ItemsWorkerResult) -> Void)
}

extension Listen {

    typealias ItemsWorker = ListenItemsWorker

    enum ItemsWorkerResult {
        case success([Model.Item])
        case failure
    }

    class ItemsWorkerImp {

        //let listenApi: ListenApi

        init(/*listenApi: ListenApi*/) {
            //self.listenApi = listenApi
        }
    }
}

extension Listen.ItemsWorkerImp: Listen.ItemsWorker {

    func removeItem(with itemId: String, completion:  @escaping (ItemsWorkerResult) -> Void) {
    }

    func fetchItems(completion: @escaping (ItemsWorkerResult) -> Void) {
//        listenApi.requestItemsList { (result) in
//            switch result {
//            case .success(let items):
//                completion(.success(items))
//            case .failure:
//                completion(.failure)
//            }
//        }

        completion(.success([
            Listen.Event.Model.Item(
                itemId: "1",
                imageUrl: "https://fainaidea.com/wp-content/uploads/2018/10/unnamed.jpg",
                iconUrl: "https://fainaidea.com/wp-content/uploads/2018/10/unnamed.jpg",
                publisher: "String",
                title: "String",
                duration: "String",
                summary: "String",
                episode: nil
            ),
            Listen.Event.Model.Item(
                itemId: "2",
                imageUrl: "https://fainaidea.com/wp-content/uploads/2018/10/unnamed.jpg",
                iconUrl: "https://fainaidea.com/wp-content/uploads/2018/10/unnamed.jpg",
                publisher: "String",
                title: "String",
                duration: "String",
                summary: "String",
                episode: "String"
            ),
            Listen.Event.Model.Item(
                itemId: "3",
                imageUrl: "https://fainaidea.com/wp-content/uploads/2018/10/unnamed.jpg",
                iconUrl: "https://fainaidea.com/wp-content/uploads/2018/10/unnamed.jpg",
                publisher: "String",
                title: "String",
                duration: "String",
                summary: "String",
                episode: "String"
            ),
            Listen.Event.Model.Item(
                itemId: "4",
                imageUrl: "https://fainaidea.com/wp-content/uploads/2018/10/unnamed.jpg",
                iconUrl: "https://fainaidea.com/wp-content/uploads/2018/10/unnamed.jpg",
                publisher: "String",
                title: "String",
                duration: "String",
                summary: "String",
                episode: "String"
            )
            ]
))
    }
}

