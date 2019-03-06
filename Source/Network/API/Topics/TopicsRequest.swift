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
    case subscribedTopicsList
}

struct TopicsTarget: TargetType {
    
    let baseURL: URL
    let request: TopicsRequest

    var path: String {
        switch request {

        case .topicList: return "topicList/"
        case .subtopicList: return "subTopicList/"
        case .subscribedTopicsList: return "topics/"
        }
    }

    var method: Moya.Method {
        switch request {

        case .topicList,
             .subtopicList,
             .subscribedTopicsList:
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

        case .subscribedTopicsList:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
