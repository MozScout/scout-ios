//
//  Intent.swift
//  Scout
//
//

import Foundation
import SnipsPlatform

enum Intent {

    case volumeUp(value: Int)
    case volumeDown(value: Int)
    case play
    case pause

    init?(message: IntentMessage) {
        switch message.intent.intentName {
        case "volumeUp":
            let value: Int
            if let slot = message.slots.first(where: { $0.slotName == "volume_higher" }) {
                switch slot.value {
                case .custom(let number):
                    value = Int(number) ?? 1
                default:
                    value = 1
                }
            } else {
                value = 1
            }

            self = .volumeUp(value: value)
        case "volumeDown":
            let value: Int
            if let slot = message.slots.first(where: { $0.slotName == "volume_lower" }) {
                switch slot.value {
                case .custom(let number):
                    value = Int(number) ?? 1
                default:
                    value = 1
                }
            } else {
                value = 1
            }

            self = .volumeDown(value: value)
        case "resumeMusic", "Resume":
            self = .play
        case "Stop", "speakerInterrupt":
            self = .pause
        default:
            return nil
        }
    }
}
