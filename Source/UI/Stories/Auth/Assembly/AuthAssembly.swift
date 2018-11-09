//
//  MainAssembly.swift
//  Scout
//
//

import Foundation
import UIKit

class AuthAssembly: AuthAssemblyProtocol {

    let applicationAssembly: ApplicationAssemblyProtocol

    required init(withAssembly assembly: ApplicationAssemblyProtocol) {

        self.applicationAssembly = assembly
    }

    func assemblyLoginViewController() -> LoginViewController {

        let loginVC = self.storyboard.instantiateViewController(
            withIdentifier: "LoginViewController") as! LoginViewController

        return loginVC
    }
}

// MARK: -
// MARK: Storyboard
fileprivate extension AuthAssembly {

    var storyboard: UIStoryboard { return UIStoryboard(name: "Auth", bundle: nil) }
}
