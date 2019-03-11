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

    private var currentCancellable: CancellableToken?

    // MARK: -

    init(
        generalApi: GeneralApi,
        fileManager: FileManager
        ) {

        self.generalApi = generalApi
        self.fileManager = fileManager
    }

    // MARK: - Public methods

    enum LoadAudioResult {
        case success(URL)
        case failure
    }

    func loadSummary(
        for url: URL,
        completion: @escaping (LoadAudioResult) -> Void
        ) {

        let postModel = ArticlePostModel(url: url)
        currentCancellable?.cancel()

        currentCancellable = generalApi.summary(for: postModel) { [weak self] (result) in
            switch result {

            case .success(let response):
                self?.loadAudio(
                    from: response.audioUrl,
                    completion: completion
                )

            case .failure(let error):
                print(.error(error: error.localizedDescription))
            }
        }
    }

    func loadArticle(
        for url: URL,
        completion: @escaping (LoadAudioResult) -> Void
        ) {

        let postModel = ArticlePostModel(url: url)
        currentCancellable?.cancel()

        currentCancellable = generalApi.article(for: postModel) { [weak self] (result) in
            switch result {

            case .success(let response):
                self?.loadAudio(
                    from: response.audioUrl,
                    completion: completion
                )

            case .failure(let error):
                print(.error(error: error.localizedDescription))
            }
        }
    }

    func loadAudio(
        from url: URL,
        completion: @escaping (LoadAudioResult) -> Void
        ) {

        currentCancellable?.cancel()

        let localUrl = self.localUrl(from: url)

        guard !audioExists(at: localUrl) else {
            completion(.success(localUrl))
            return
        }

        currentCancellable = generalApi.loadAudio(
            from: url,
            to: localUrl,
            completion: { (result) in
                switch result {
                    
                case .success:
                    completion(.success(localUrl))
                    
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
