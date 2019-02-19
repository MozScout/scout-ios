//
//  Codable+Extensions.swift
//  Scout
//
//

import Foundation

let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

let jsonEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    return encoder
}()

extension Decodable {
    static func decode(from data: Data, using decoder: JSONDecoder = jsonDecoder) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}

extension Encodable {
    func encode(using encoder: JSONEncoder = jsonEncoder) throws -> Data {
        return try encoder.encode(self)
    }
}
