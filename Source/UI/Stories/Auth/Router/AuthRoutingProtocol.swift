//
//  MainRoutingProtocol.swift
//  Scout
//
//

import Foundation
import UIKit

protocol AuthRoutingProtocol {
    var onSignInTap: ((UIViewController) -> Void)? { get set }
    
    func safariViewControllerDidFinish(viewController: UIViewController)
    func show(from viewController: UIViewController, animated: Bool)
}
