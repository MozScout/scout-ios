//
//  MainRoutingProtocol.swift
//  Scout
//
//

import Foundation
import UIKit

enum MainTab: Int {
    case podcasts = 0
    case articles = 1
    case settings = 2
}

protocol MainRoutingProtocol {
    var userID: String { get set }
    // MARK: Routing
    func showMainUIInterface(fromViewController viewController: UINavigationController, animated: Bool)
    func showMainUITab(tab: MainTab, animated: Bool)
}
