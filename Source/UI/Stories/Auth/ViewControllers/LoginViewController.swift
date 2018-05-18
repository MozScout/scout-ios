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
        safariVC = SFSafariViewController(url: URL(string:"http://moz-scout.herokuapp.com/api/auth/mobile/login")!)
        safariVC?.delegate = self
        self.present(safariVC!, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        guard let requiredDelegate = safariDoneButtonDelegate else { return }
        requiredDelegate.safariViewControllerDidFinish(viewController: self)
        dismiss(animated: true)
    }
}
