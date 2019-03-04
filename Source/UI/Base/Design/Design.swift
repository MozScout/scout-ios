//
//  Design.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/9/18.
//

import Foundation
import HexColors

public struct Design {
    public struct Color {
        public static let clear = UIColor.clear
        public static let black = UIColor.black
        public static let blue = UIColor("#0090ED")!
        public static let lightBlue = UIColor("#004690")!
        public static let purple = UIColor("#D226EE")!
        public static let standardWhite = UIColor("#FFFFFF")!
        public static let darkWhite = UIColor("#F9F9FA")!
        public static let red = UIColor("#FF3858")!
        public static let orange = UIColor("#FF9C4A")!

        public static func from(hexString string: String) -> UIColor {
            return UIColor(string)!
        }

        public static func optionalFrom(hexString string: String) -> UIColor? {
            return UIColor(string)
        }
    }
}
