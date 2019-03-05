//
//  ListenDurationFormatterImp.swift
//  Scout
//
//

import Foundation

extension Listen {

    class DurationFormatterImp { }
}

extension Listen.DurationFormatterImp: Listen.DurationFormatter {

    func format(duration: Int64) -> String {
        let inMinutes: Int64 = duration
        let inHours: Int64 = inMinutes / 60

        if inMinutes < 2 {
            return "\(inMinutes) min"
        } else if inMinutes < 60 {
            return "\(inMinutes) mins"
        } else if inHours < 2 {
            return "\(inHours) hr"
        } else {
            return "\(inHours) hrs"
        }
    }
}
