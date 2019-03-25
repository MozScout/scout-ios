//
//  OnboardingRegisterWorker.swift
//  Scout
//
//

import Foundation

enum OnboardingRegisterWorkerRegisterResult {
    case success
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
        let accessTokenManager: AccessTokenManager
        let userDataManager: UserDataManager

        init(
            registerApi: RegisterApi,
            accessTokenManager: AccessTokenManager,
            userDataManager: UserDataManager
            ) {

            self.registerApi = registerApi
            self.accessTokenManager = accessTokenManager
            self.userDataManager = userDataManager
        }
    }
}

extension Onboarding.RegisterWorkerImp: Onboarding.RegisterWorker {

    func register(
        with topics: [String],
        completion: @escaping (RegisterResult) -> Void
        ) {

        let postModel = RegisterPostModel(topics: topics)
        registerApi.register(with: postModel) { [weak self] (result) in
            switch result {

            case .success(let response):
                self?.accessTokenManager.setBearerToken(response.token)
                self?.userDataManager.userId = response.userId
                completion(.success)
            case .failure:
                completion(.failure)
            }
        }
    }
}
