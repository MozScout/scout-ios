//
//  ListenListApi.swift
//  Scout
//
//

import Foundation

class ListenListApi: BaseApi {

    // MARK: - Request listen list -

    enum RequestListenListResult {
        case success([ListenListItem])
        case failure
    }

    @discardableResult
    func requestListenList(
        completion: @escaping (RequestListenListResult) -> Void
        ) -> CancellableToken {

        let target = ListenListTarget(
            baseURL: baseUrl,
            request: .listenList,
            tokenProvider: accessTokenProvider
        )

        return apiClient.requestObject(
            target: target,
            responseType: [ListenListItem].self,
            callbackQueue: nil,
            success: { (items) in
                completion(.success(items))
        }) { (_) in
            completion(.failure)
        }
    }

    // MARK: - Delete listen list item -

    enum DeleteListenListItemResult {
        case success
        case failure
    }

    @discardableResult
    func deleteListenListItem(
        with postModel: DeleteListenListItemPostModel,
        completion: @escaping (DeleteListenListItemResult) -> Void
        ) -> CancellableToken {

        let target = ListenListTarget(
            baseURL: baseUrl,
            request: .deleteListenListItem(postModel: postModel),
            tokenProvider: accessTokenProvider
        )

        return apiClient.requestObject(
            target: target,
            responseType: DeleteListenListItemResponse.self,
            callbackQueue: nil,
            success: { (_) in
                completion(.success)
        }) { (_) in
            completion(.failure)
        }
    }
}
