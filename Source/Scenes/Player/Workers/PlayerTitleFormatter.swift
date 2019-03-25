//
//  PlayerTitleFormatter.swift
//  Scout
//
//

import Foundation

protocol PlayerTitleFormatter {

    func formatTitle(_ string: String) -> NSAttributedString
}

extension Player {

    typealias TitleFormatter = PlayerTitleFormatter
}
