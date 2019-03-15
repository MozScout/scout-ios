//
//  PlayerTimeFormatterImp.swift
//  Scout
//
//

import Foundation

extension Player {
    class TimeFormatterImp: TimeFormatter {

        func formatPlayed(_ seconds: Int64?) -> String {
            return formatSeconds(seconds)
        }

        func formatRemaining(_ seconds: Int64?) -> String {
            return [(seconds == nil ? "" : "-"), formatSeconds(seconds)].joined()
        }

        private func formatSeconds(_ seconds: Int64?) -> String {
            guard let seconds = seconds else { return "--:--" }

            let minutes: Int64 = seconds / 60
            let secondsRemaining: Int64 = seconds % 60

            return "\(minutes):\(secondsRemaining)"
        }
    }
}
