//
//  SettingsViewController.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/9/18.
//

import Foundation
import SafariServices
import UIKit

class SettingsViewController: UIViewController, SFSafariViewControllerDelegate {
    @IBOutlet fileprivate weak var mainTitleLabel: UILabel!
    @IBOutlet fileprivate var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var gradientButton: GradientButton!

    private var safariVC: SFSafariViewController?

    var keychainService: KeychainService!

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
    }

    // MARK: Private
    fileprivate func configureUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.tapFunction))
        infoLabel.isUserInteractionEnabled = true
        infoLabel.addGestureRecognizer(tap)

        gradientButton.direction = .horizontally(centered: 0.1)

        let rawCenterString: NSString = """
        Mozilla strives to only collect what we need to provide and improve Scout for everyone. Learn More.
        """
        let centerText = NSMutableAttributedString(string: rawCenterString as String,
                                                   attributes: [
                                                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)
                                                   ])

        let policyText = "Learn More."
        let policyRange = rawCenterString.range(of: policyText)
        rawCenterString.enumerateSubstrings(in: policyRange, options: .byWords, using: { (_, substringRange, _, _) in
            centerText.addAttribute(NSAttributedString.Key.foregroundColor,
                                    value: UIColor(rgb: 0x0060DF),
                                    range: substringRange)
            })

        infoLabel.attributedText = centerText

        if let userID = keychainService.value(for: "userID") {
            accountLabel.text = "Account (\(userID))"
        }
    }

    @objc func tapFunction(sender: UITapGestureRecognizer) {
        guard let privacyURL = URL(string: "https://www.mozilla.org/en-US/privacy/") else {
            return //be safe
        }

        safariVC = SFSafariViewController(url: privacyURL)
        safariVC!.delegate = self
        self.present(safariVC!, animated: true, completion: nil)
    }
}
