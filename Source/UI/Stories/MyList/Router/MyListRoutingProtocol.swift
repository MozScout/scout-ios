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
    func show(from viewController: UIViewController, animated: Bool, withUserID: String)
}
