//
//  OperationResult.swift
//  Scout
//
//

import Foundation

enum OperationResult<Data, Error> {

    case success(data: Data)
    case failure(error: Error)
}
