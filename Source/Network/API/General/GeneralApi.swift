//
//  GeneralApi.swift
//  Scout
//
//

import Foundation
import Moya
import Alamofire

class GeneralApi: BaseApi {

    // MARK: - Load audio -

    enum LoadAudioResult {
        case success
        case failure(Error)
    }

    @discardableResult
    func loadAudio(
        from url: URL,
        to destinationUrl: URL,
        completion: @escaping (LoadAudioResult) -> Void
        ) -> CancellableToken {

        let target = GeneralTarget(
            baseURL: url,
            request: .downloadAudio({ (temporaryUrl, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
                return (destinationUrl, .removePreviousFile)
            }),
            tokenProvider: accessTokenProvider
        )

        return apiClient.requestEmpty(
            target: target,
            callbackQueue: nil,
            success: {
                completion(.success)
        }) { (error) in
            completion(.failure(error))
        }
    }

    // MARK: - Article -

    typealias ArticleResult = GenericArticleResult

    @discardableResult
    func article(
        for postModel: ArticlePostModel,
        completion: @escaping (ArticleResult) -> Void
        ) ->  CancellableToken {

        let target = GeneralTarget(
            baseURL: baseUrl,
            request: .article(postModel),
            tokenProvider: accessTokenProvider
        )

        return genericArticle(target: target, completion: completion)
    }

    // MARK: - Summary -

    typealias SummaryResult = GenericArticleResult

    @discardableResult
    func summary(
        for postModel: ArticlePostModel,
        completion: @escaping (SummaryResult) -> Void
        ) ->  CancellableToken {

        let target = GeneralTarget(
            baseURL: baseUrl,
            request: .summary(postModel),
            tokenProvider: accessTokenProvider
        )

        return genericArticle(target: target, completion: completion)
    }

    // MARK: - Private methods

    enum GenericArticleResult {
        case success(ArticleResponse)
        case failure(Error)
    }

    private func genericArticle<Target: TargetType>(
        target: Target,
        completion: @escaping (GenericArticleResult) -> Void
        ) -> CancellableToken {

        return apiClient.requestObject(
            target: target,
            responseType: ArticleResponse.self,
            callbackQueue: nil,
            success: { (response) in
                completion(.success(response))
        },
            error: { (error) in
                completion(.failure(error))
        })
    }
}
