//
//  SubscriptionsDateFormatter.swift
//  Scout
//
//

import Foundation

protocol SubscriptionsDateFormatter {

    func formatItemDate(_ date: Date) -> String
}

extension Subscriptions {

    typealias DateFormatter = SubscriptionsDateFormatter
}
