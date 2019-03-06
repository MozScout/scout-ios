//
//  PlayerWorker.swift
//  Scout
//
//

import Foundation

protocol PlayerPlayerWorker {

    func play()
    func pause()
}

extension Player {

    typealias PlayerWorker = PlayerPlayerWorker
}
