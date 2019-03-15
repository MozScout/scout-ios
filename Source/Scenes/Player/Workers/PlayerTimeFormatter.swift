//
//  PlayerTimeFormatter.swift
//  Scout
//
//

import Foundation

protocol PlayerTimeFormatter {

    func formatPlayed(_ seconds: Int64?) -> String
    func formatRemaining(_ seconds: Int64?) -> String
}

extension Player {
    
    typealias TimeFormatter = PlayerTimeFormatter
}
