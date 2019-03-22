//
//  SubscriptionsDateFormatterImp.swift
//  Scout
//
//

import Foundation

extension Subscriptions {

    class DateFormatterImp {

        private lazy var dateFormatter: Foundation.DateFormatter = {
            let formatter = Foundation.DateFormatter()

            formatter.dateFormat = "MMM dd, yyyy"

            return formatter
        }()
    }
}

extension Subscriptions.DateFormatterImp: Subscriptions.DateFormatter {

    func formatItemDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
