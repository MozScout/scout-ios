//
//  PlayerAudioLoader.swift
//  Scout
//
//

import Foundation

class PlayerAudioLoader {

    // MARK: - Private properties

    private let generalApi: GeneralApi
    private let fileManager: FileManager

    // MARK: -

    init(
        generalApi: GeneralApi,
        fileManager: FileManager
        ) {

        self.generalApi = generalApi
        self.fileManager = fileManager
    }

    // MARK: - Public methods

    enum LoadArticleResult {
        case success(response: ArticleResponse)
        case failure
    }

    func loadSummary(
        for url: URL,
        completion: @escaping (LoadArticleResult) -> Void
        ) -> CancellableToken {

        let postModel = ArticlePostModel(url: url)
        return generalApi.summary(for: postModel) { [weak self] (result) in
            self?.loadArticleCompletion(result: result, completion: completion)
        }
    }

    func loadArticle(
        for url: URL,
        completion: @escaping (LoadArticleResult) -> Void
        ) -> CancellableToken {

        let postModel = ArticlePostModel(url: url)
        return generalApi.article(for: postModel) { [weak self] (result) in
            self?.loadArticleCompletion(result: result, completion: completion)
        }
    }

    private func loadArticleCompletion(
        result: GeneralApi.GenericArticleResult,
        completion: @escaping (LoadArticleResult) -> Void
        ) {

        switch result {

        case .success(let response):
            completion(.success(response: response))

        case .failure(let error):
            print(.error(error: error.localizedDescription))
            completion(.failure)
        }
    }

    enum LoadAudioResult {
        case success(localUrl: URL)
        case failure
    }

    func loadAudio(
        from url: URL,
        completion: @escaping (LoadAudioResult) -> Void
        ) -> CancellableToken {

        let localUrl = self.localUrl(from: url)

        guard !audioExists(at: localUrl) else {
            completion(.success(localUrl: localUrl))
            return EmptyCancellableToken()
        }

        return generalApi.loadAudio(
            from: url,
            to: localUrl,
            completion: { (result) in
                switch result {
                    
                case .success:
                    completion(.success(localUrl: localUrl))
                    
                case .failure(let error):
                    print(.error(error: error.localizedDescription))
                    completion(.failure)
                }
        })
    }

    // MARK: - Private methods

    private func audioExists(at url: URL) -> Bool {
        return fileManager.fileExists(atPath: url.path)
    }

    private func localUrl(from url: URL) -> URL {

        var localUrl: URL!

        repeat {
            localUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        } while localUrl == nil

        if localUrl == nil {
            print(.fatalError(error: "Cannot get url"))
            localUrl = fileManager.temporaryDirectory
        }

        return localUrl.appendingPathComponent(url.lastPathComponent)
    }
}
