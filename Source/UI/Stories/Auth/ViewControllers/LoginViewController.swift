//
//  LoginViewController.swift
//  Scout
//
//  Created by Shurupov Alex on 5/16/18.
//

import SafariServices
import UIKit

protocol safariDoneButtonDelegate: class {
    func safariViewControllerDidFinish(viewController: UIViewController)
}

class LoginViewController: UIViewController, SFSafariViewControllerDelegate {

    weak var safariDoneButtonDelegate: safariDoneButtonDelegate?
    private var safariVC: SFSafariViewController?

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
        guard let authURL = URL(string: "http://scout-stage.herokuapp.com/api/auth/mobile/login") else {
            return //be safe
        }

        safariVC = SFSafariViewController(url: authURL)
        safariVC!.delegate = self
        self.present(safariVC!, animated: true, completion: nil)
    }

    private func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismiss(animated: true) { () -> Void in
            print("You just dismissed the login view.")
        }
    }

    private func safariViewController(controller: SFSafariViewController,
                                      didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("didLoadSuccessfully: \(didLoadSuccessfully)")
    }
}
