//
//  UIFont+Design.swift
//  Scout
//
//

import UIKit

extension UIFont {
    enum SfProTextStyle: String {
        case bold = "Bold"
        case boldItalic = "BoldItalic"
        case heavy = "Heavy"
        case heavyItalic = "HeavyItalic"
        case light = "Light"
        case lightItalic = "LightItalic"
        case medium = "Medium"
        case mediumItalic = "MediumItalic"
        case regular = "Regular"
        case regularItalic = "RegularItalic"
        case semibold = "Semibold"
        case semiboldItalic = "SemiboldItalic"
    }

    enum SfProDisplayStyle: String {
        case black = "Black"
        case blackItalic = "BlackItalic"
        case bold = "Bold"
        case boldItalic = "BoldItalic"
        case heavy = "Heavy"
        case heavyItalic = "HeavyItalic"
        case light = "Light"
        case lightItalic = "LightItalic"
        case medium = "Medium"
        case mediumItalic = "MediumItalic"
        case regular = "Regular"
        case regularItalic = "RegularItalic"
        case semibold = "Semibold"
        case semiboldItalic = "SemiboldItalic"
        case thin = "Thin"
        case thinItalic = "ThinItalic"
        case ultralight = "Ultralight"
        case ultralightItalic = "UltralightItalic"
    }

    class func openSans(ofSize size: CGFloat) -> UIFont {
        return makeFont(name: "OpenSans", ofSize: size)
    }

    class func sfProText(_ style: SfProTextStyle, ofSize size: CGFloat) -> UIFont {
        return makeFont(name: "SFProText-\(style.rawValue)", ofSize: size)
    }

    class func sfProDisplay(_ style: SfProDisplayStyle, ofSize size: CGFloat) -> UIFont {
        return makeFont(name: "SFProDisplay-\(style.rawValue)", ofSize: size)
    }

    private class func makeFont(name: String, ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            for family in UIFont.familyNames.sorted() {
                let names = UIFont.fontNames(forFamilyName: family)
                print("Family: \(family) Font names: \(names)")
            }

            assertionFailure("Can't find \(name) font")
            return .systemFont(ofSize: size)
        }

        return font
    }
}

