//
//  PlayerItemProvider.swift
//  Scout
//
//

import Foundation
import RxSwift

protocol PlayerItemProvider {

    func observeItem() -> Observable<Player.Model.Item?>
}

extension Player {

    typealias ItemProvider = PlayerItemProvider
}
