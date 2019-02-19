//
//  TopicsRequest.swift
//  Scout
//
//

import Foundation
import Moya

enum TopicsRequest {
    case topicList
    case subtopicList(topicId: Int64)
}

struct TopicsTarget: TargetType {
    
    let baseURL: URL
    let request: TopicsRequest

    var path: String {
        switch request {

        case .topicList: return "topicList/"
        case .subtopicList: return "subTopicList"
        }
    }

    var method: Moya.Method {
        switch request {

        case .topicList,
             .subtopicList:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch request {

        case .topicList:
            return .requestPlain

        case .subtopicList(let topicId):
            return .requestParameters(
                parameters: ["topicId": topicId],
                encoding: URLEncoding()
            )
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
