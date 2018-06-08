//
//  LoginViewController.swift
//  Scout
//
//  Created by Shurupov Alex on 5/16/18.
//

import UIKit
import SafariServices

protocol safariDoneButtonDelegate: class {
    func safariViewControllerDidFinish(viewController: UIViewController)
}

class LoginViewController: UIViewController, SFSafariViewControllerDelegate {
   
    weak var safariDoneButtonDelegate: safariDoneButtonDelegate?
    var safariVC: SFSafariViewController?
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func configureUI() {
        signInButton.layer.cornerRadius = 3
        signInButton.clipsToBounds = true
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let url = URL(string: "http://scout-stage.herokuapp.com/api/auth/mobile/login") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
