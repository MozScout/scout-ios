//
//  MainRoutingProtocol.swift
//  Scout
//
//

import Foundation
import UIKit

protocol MyListRoutingProtocol {
    
    var linkIsFound: ((ScoutArticle, Bool) -> Void)? { get set }
    func show(from viewController: UIViewController, animated: Bool, withUserID: String)
}
