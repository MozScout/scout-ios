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
        public static let white = UIColor.white
        public static let black = UIColor.black
        public static let blue = UIColor("#0060DF")!
        public static let lightBlue = UIColor("#45A1FF")!
        public static let purple = UIColor("#9E4DFB")!
        public static let standartWhite = UIColor("#FFFFFF")!
        public static let darkWhite = UIColor("#F9F9FA")!

        public static func from(hexString string: String) -> UIColor {
            return UIColor(string)!
        }

        public static func optionalFrom(hexString string: String) -> UIColor? {
            return UIColor(string)
        }
    }

    public enum Font {
        case regular(size: CGFloat)
        case heavy(size: CGFloat)
        case light(size: CGFloat)

        public var value: UIFont {
            switch self {
                case let .regular(size):
                    return UIFont.systemFont(ofSize: size, weight: .regular)
                case let .heavy(size):
                    return UIFont.systemFont(ofSize: size, weight: .heavy)
                case let .light(size):
                    return UIFont.systemFont(ofSize: size, weight: .light)
            }
        }
    }

    public static func attributedString(from string: String,
                                        font: UIFont,
                                        spacing: CGFloat) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedString.Key.font,
                                      value: font,
                                      range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: spacing,
                                      range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }

    public static func attributedString(from string: String,
                                        font: UIFont,
                                        interlineage: CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = interlineage

        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value: paragraphStyle,
                                range: NSRange(location: 0, length: attrString.length))
        attrString.addAttribute(NSAttributedString.Key.font,
                                value: font,
                                range: NSRange(location: 0, length: attrString.length))

        return attrString
    }

    public static func image(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)

        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }

        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image ?? UIImage()
    }
}
