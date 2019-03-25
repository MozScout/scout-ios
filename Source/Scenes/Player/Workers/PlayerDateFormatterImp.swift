//
//  PlayerDateFormatterImp.swift
//  Scout
//
//

import Foundation

extension Player {
    
    class DateFormatterImp {

        private lazy var dateFormatter: Foundation.DateFormatter = {
            let formatter = Foundation.DateFormatter()
            formatter.dateFormat = "MMM dd, yyyy"
            return formatter
        }()
    }
}

extension Player.DateFormatterImp: Player.DateFormatter {

    func formatPublishingDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
