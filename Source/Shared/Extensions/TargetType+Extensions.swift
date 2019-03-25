//
//  TargetType+Extensions.swift
//  Scout
//
//

import Foundation
import Moya

extension TargetType {
    
    /// Converts `Encodable` parameters to `Dictionary` and puts it to `.requestParameters` task with query string encoding.
    ///
    /// - Parameter parameters: Encodable parameters structure
    /// - Returns: `.requestParameters` task with `URLEncoding.queryString` encoding
    func urlEncodedRequestParameters<Parameters: Encodable>(with parameters: Parameters) -> Task {
        return .requestParameters(
            parameters: parameters.toDictionary(using: urlQueryEncoder),
            encoding: URLEncoding.queryString
        )
    }
}

private let urlQueryEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .useDefaultKeys
    return encoder
}()

private extension Encodable {

    func toDictionary(using encoder: JSONEncoder = urlQueryEncoder) -> [String: Any] {
        guard let data: Data = try? encode(using: encoder),
            let optionalDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let dictionary = optionalDictionary as? [String: Any]
            else {
                print(.error(error: "Cannot convert object to dictionary, object: \(self)"))
                return [:]
        }
        return dictionary
    }
}
