//
//  VoiceInputRoutingProtocol.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import Foundation
import UIKit

protocol VoiceInputRoutingProtocol {
    var onCloseButtonTap: (() -> Void)? { get set }
    func show(from viewController: UIViewController, animated: Bool)
    func addText(_ text: String, fromUser: Bool)
    func setImage(_ image: UIImage)
}
