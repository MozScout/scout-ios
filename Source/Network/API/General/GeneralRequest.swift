//
//  GeneralRequest.swift
//  Scout
//
//

import Foundation
import Moya

enum GeneralRequest {
    case downloadAudio(_ downloadDestination: DownloadDestination)
    case article(_ postModel: ArticlePostModel)
    case summary(_ postModel: ArticlePostModel)
}

struct GeneralTarget: TargetType {

    let baseURL: URL
    let request: GeneralRequest
    let tokenProvider: RequestAuthorizationTokenProvider

    var path: String {
        switch request {

        case .downloadAudio: return ""
        case .article: return "article"
        case .summary: return "summary"
        }
    }

    var method: Moya.Method {
        switch request {

        case .downloadAudio:
            return .get

        case .article,
             .summary:
            return .post
        }
    }

    var sampleData: Data { return Data() }

    var task: Task {
        switch request {

        case .downloadAudio(let destination):
            return .downloadDestination(destination)
            
        case .article(let postModel),
             .summary(let postModel):
            return .requestJSONEncodable(postModel)
        }
    }

    var headers: [String : String]? {
        switch request {

        case .downloadAudio:
            return nil
        case .article,
             .summary:
            if let token = tokenProvider.bearerToken {
                return ["Authorization": "Bearer \(token)"]
            } else {
                print(.error(error: "No authorization token"))
                return nil
            }
        }
    }
}
