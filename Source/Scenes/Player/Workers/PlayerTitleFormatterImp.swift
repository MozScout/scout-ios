//
//  PlayerTitleFormatterImp.swift
//  Scout
//
//

import Foundation
import UIKit

extension Player {
    
    class TitleFormatterImp { }
}

extension Player.TitleFormatterImp: Player.TitleFormatter {

    func formatTitle(_ string: String) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [:]

        let font = UIFont.sfProText(.semibold, ofSize: 14)

        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 21 - font.lineHeight
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping

        attributes[.paragraphStyle] = paragraphStyle
        attributes[.font] = font
        attributes[.foregroundColor] = UIColor.fxBlack

        return NSAttributedString(string: string, attributes: attributes)
    }
}
