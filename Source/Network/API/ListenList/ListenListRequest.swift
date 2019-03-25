//
//  ListenListRequest.swift
//  Scout
//
//

import Foundation
import Moya

enum ListenListRequest {
    case listenList
    case deleteListenListItem(postModel: DeleteListenListItemPostModel)
}

struct ListenListTarget: TargetType {

    let baseURL: URL
    let request: ListenListRequest
    let tokenProvider: RequestAuthorizationTokenProvider

    var path: String {
        switch request {

        case .deleteListenListItem,
             .listenList:
            return "listenList"
        }
    }

    var method: Moya.Method {
        switch request {

        case .deleteListenListItem: return .delete
        case .listenList: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch request {

        case .listenList:
            return .requestPlain

        case .deleteListenListItem(let postModel):
            return .requestJSONEncodable(postModel)
        }
    }

    var headers: [String: String]? {
        switch request {
        case .listenList,
             .deleteListenListItem:
            if let token = tokenProvider.bearerToken {
                return ["Authorization": "Bearer \(token)"]
            } else {
                print(.error(error: "No authorization token"))
                return nil
            }
        }
    }
}
