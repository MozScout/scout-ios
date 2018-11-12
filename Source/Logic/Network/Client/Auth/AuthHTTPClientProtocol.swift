//
//  AuthHTTPClientProtocol.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/12/18.
//

import Foundation

typealias CreateNewUserSuccessBlock = (_ userToken: String) -> Void
typealias CreateNewUserFailureBlock = HTTPClientFailureBlock

protocol AuthHTTPClientProtocol {
}
