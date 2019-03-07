//
//  PlayerWorkerImp.swift
//  Scout
//
//

import Foundation

extension Player {

    typealias PlayerWorkerImp = PlayerService
}

extension PlayerService: Player.PlayerWorker { }
