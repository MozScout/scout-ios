//
//  ListenDurationFormatter.swift
//  Scout
//
//

import Foundation

protocol ListenDurationFormatter {
    func format(duration: Int64) -> String
}

extension Listen {
    
    typealias DurationFormatter = ListenDurationFormatter
}
