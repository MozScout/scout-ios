//
//  PlayerTimeFormatter.swift
//  Scout
//
//

import Foundation

protocol PlayerTimeFormatter {

    func formatPlayed(_ seconds: TimeInterval?) -> String
    func formatRemaining(_ seconds: TimeInterval?) -> String
}

extension Player {
    
    typealias TimeFormatter = PlayerTimeFormatter
}
