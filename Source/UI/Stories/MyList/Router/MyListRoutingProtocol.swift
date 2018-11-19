//
//  MainRoutingProtocol.swift
//  Scout
//
//

import Foundation
import UIKit

protocol MyListRoutingProtocol {
    var linkIsFound: ((ScoutArticle, Bool) -> Void)? { get set }
    var pausePlayer: (() -> Void)? { get set }
    var stopPlayer: (() -> Void)? { get set }
    var resumePlayer: (() -> Void)? { get set }
    var isPlaying: (() -> Bool)? { get set }
    var isPlayerVisible: (() -> Bool)? { get set }
    var increasePlayerVolume: (() -> Void)? { get set }
    var decreasePlayerVolume: (() -> Void)? { get set }
    var setPlayerVolume: ((Float) -> (Float, Float)?)? { get set }
    var increasePlayerSpeed: (() -> Void)? { get set }
    var decreasePlayerSpeed: (() -> Void)? { get set }
    var skipPlayerTime: ((Int) -> Void)? { get set }
    func show(from viewController: UIViewController, animated: Bool, withUserID: String)
}
