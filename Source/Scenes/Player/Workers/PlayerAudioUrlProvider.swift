//
//  PlayerAudioUrlProvider.swift
//  Scout
//
//

import Foundation

protocol PlayerAudioUrlProvider {

    var audioUrl: URL? { get }
}

extension Player {

    typealias AudioUrlProvider = PlayerAudioUrlProvider
}
