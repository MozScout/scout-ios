//
//  RegisterRequest.swift
//  Scout
//
//

import Foundation
import Moya

enum RegisterRequest {
    case register(postModel: RegisterPostModel)
}

struct RegisterTarget: TargetType {

    let baseURL: URL
    let request: RegisterRequest

    var path: String {
        switch request {

        case .register: return "register"
        }
    }

    var method: Moya.Method {
        switch request {

        case .register: return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch request {

        case .register(let postModel):
            return .requestJSONEncodable(postModel)
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
