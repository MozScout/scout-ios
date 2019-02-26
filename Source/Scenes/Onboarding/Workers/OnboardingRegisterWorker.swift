//
//  OnboardingRegisterWorker.swift
//  Scout
//
//

import Foundation

struct OnboardingRegisterWorkerRegisterResponse {
    let userId: String
    let token: String
}

enum OnboardingRegisterWorkerRegisterResult {
    case success(response: OnboardingRegisterWorkerRegisterResponse)
    case failure
}

protocol OnboardingRegisterWorker {

    typealias RegisterResult = OnboardingRegisterWorkerRegisterResult

    func register(
        with topics: [String],
        completion: @escaping (RegisterResult) -> Void
    )
}

extension Onboarding {

    typealias RegisterWorker = OnboardingRegisterWorker

    class RegisterWorkerImp {

        let registerApi: RegisterApi

        init(registerApi: RegisterApi) {
            self.registerApi = registerApi
        }
    }
}

extension Onboarding.RegisterWorkerImp: Onboarding.RegisterWorker {

    func register(
        with topics: [String],
        completion: @escaping (RegisterResult) -> Void
        ) {

        let postModel = RegisterPostModel(topics: topics)
        registerApi.register(with: postModel) { (result) in
            switch result {

            case .success(let response):
                let response = OnboardingRegisterWorkerRegisterResponse(
                    userId: response.userId,
                    token: response.token
                )
                completion(.success(response: response))
            case .failure:
                completion(.failure)
            }
        }
    }
}
