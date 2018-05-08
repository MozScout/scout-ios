//
//  MainRoutingProtocol.swift
//  Scout
//
//

import Foundation
import UIKit

enum MainTab: Int {
    
    case profile = 0
}

protocol MainRoutingProtocol {
    
    func show(from viewController: UIViewController, animated: Bool)
}
