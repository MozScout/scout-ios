//
//  PlayerTimeFormatterImp.swift
//  Scout
//
//

import Foundation

extension Player {
    
    class TimeFormatterImp: TimeFormatter {

        func formatPlayed(_ seconds: TimeInterval?) -> String {
            return formatSeconds(seconds)
        }

        func formatRemaining(_ seconds: TimeInterval?) -> String {
            return [(seconds == nil ? "" : "-"), formatSeconds(seconds)].joined()
        }

        private func formatSeconds(_ seconds: TimeInterval?) -> String {
            guard let seconds = seconds else { return "--:--" }

            let minutes: Int64 = Int64(seconds) / 60
            let secondsRemaining: Int64 = Int64(seconds) % 60

            let secondsRemainingString: String
            if secondsRemaining < 10 {
                secondsRemainingString = "0\(secondsRemaining)"
            } else {
                secondsRemainingString = "\(secondsRemaining)"
            }

            return "\(minutes):\(secondsRemainingString)"
        }
    }
}
