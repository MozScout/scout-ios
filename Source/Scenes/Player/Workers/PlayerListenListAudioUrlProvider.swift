//
//  PlayerListenListAudioUrlProvider.swift
//  Scout
//
//

import Foundation

extension Player {

    class ListenListAudioUrlProvider {

        private let listenListRepo: ListenListRepo
        private let id: String

        init(
            listenListRepo: ListenListRepo,
            id: String
            ) {

            self.listenListRepo = listenListRepo
            self.id = id
        }
    }
}

extension Player.ListenListAudioUrlProvider: Player.AudioUrlProvider {
    var audioUrl: URL? {
        return listenListRepo.listenListItems.first(where: { [weak self] (item) -> Bool in
            return item.id == self?.id
        })?.url
    }
}
