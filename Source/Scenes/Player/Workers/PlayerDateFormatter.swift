//
//  PlayerDateFormatter.swift
//  Scout
//
//

import Foundation

protocol PlayerDateFormatter {

    func formatPublishingDate(_ date: Date) -> String
}

extension Player {

    typealias DateFormatter = PlayerDateFormatter
}
