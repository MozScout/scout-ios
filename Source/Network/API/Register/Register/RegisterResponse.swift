//
//  RegisterResponse.swift
//  Scout
//
//

import Foundation

struct RegisterResponse: Decodable {
    let userId: String
    let token: String
}
