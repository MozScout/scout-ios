//
//  TopicsRequest.swift
//  Scout
//
//

import Foundation
import Moya

enum TopicsRequest {
    case topicList
    case subtopicList(SubtopicListRequestParameters)
}

struct TopicsTarget: TargetType {
    
    let baseURL: URL
    let request: TopicsRequest

    var path: String {
        switch request {

        case .topicList: return "topicList/"
        case .subtopicList: return "subTopicList/"
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

        case .subtopicList(let parameters):
            return urlEncodedRequestParameters(with: parameters)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
