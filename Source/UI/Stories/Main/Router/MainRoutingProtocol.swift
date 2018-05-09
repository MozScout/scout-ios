//
//  MainRoutingProtocol.swift
//  Scout
//
//

import Foundation
import UIKit

enum MainTab: Int {
    
    case myList = 0
    case help = 1
    case settings = 2
    case audioAction = 3
}

protocol MainRoutingProtocol {
    
    // MARK: Routing
    func showMainUIInterface(fromViewController viewController: UIViewController, animated: Bool)
    func showMainUITab(tab: MainTab, animated: Bool)
}
