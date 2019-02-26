//
//  RegisterApi.swift
//  Scout
//
//

import Foundation

class RegisterApi: BaseApi {

    // MARK: - Register -

    enum RegisterResult {
        case success(RegisterResponse)
        case failure
    }

    @discardableResult
    func register(
        with postModel: RegisterPostModel,
        completion: @escaping (RegisterResult) -> Void
        ) -> CancellableToken {

        let target = RegisterTarget(
            baseURL: baseUrl,
            request: .register(postModel: postModel)
        )

        return apiClient.requestObject(
            target: target,
            responseType: RegisterResponse.self,
            callbackQueue: nil,
            success: { (response) in
                completion(.success(response))
        }) { (_) in
            completion(.failure)
        }
    }
}
