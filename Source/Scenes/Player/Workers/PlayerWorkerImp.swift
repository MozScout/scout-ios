//
//  PlayerWorkerImp.swift
//  Scout
//
//

import Foundation

extension Player {

    class PlayerWorkerImp: PlayerWorker {

        private let playerService: PlayerService

        init(
            playerService: PlayerService
            ) {

            self.playerService = playerService
        }

        func play() {
            playerService.play()
        }

        func pause() {
            playerService.pause()
        }
    }
}
