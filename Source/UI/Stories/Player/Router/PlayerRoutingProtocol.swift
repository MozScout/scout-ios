//
//  VoiceInputRoutingProtocol.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import Foundation
import UIKit

protocol PlayerRoutingProtocol {
    var onBackButtonTap: (() -> Void)? { get set }
    var onMicrophoneButtonTap: (() -> Void)? { get set }
    func show(from viewController: UIViewController, animated: Bool, model: ScoutArticle, fullArticle: Bool)
    func pause()
    func stop()
    func resume()
    func playing() -> Bool
    func increaseVolume()
    func decreaseVolume()
    func setVolume(_ volume: Float) -> (Float, Float)?
    func increaseSpeed()
    func decreaseSpeed()
    func skip(_ seconds: Int)
}
