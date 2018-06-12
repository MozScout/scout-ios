//
//  SettingsViewController.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/9/18.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet fileprivate weak var mainTitleLabel: UILabel!
    @IBOutlet fileprivate var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var gradientButton: GradientButton!
    
    @IBOutlet weak var infoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    // MARK: Private
    fileprivate func configureUI() {
        
        gradientButton.direction = .horizontally(centered: 0.1)
        
        let rawCenterString: NSString = "Mozilla strives to only collect what we need to provide and improve Scout for everyone. Learn More."
        let centerText = NSMutableAttributedString(string: rawCenterString as String, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0)])
       
        let policyText = "Learn More."
        
        let policyRange = rawCenterString.range(of: policyText)
        
        
        rawCenterString.enumerateSubstrings(in:policyRange, options: .byWords, using: {
            (substring, substringRange, _, _) in
            centerText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(rgb: 0x0060DF), range: substringRange)
            })
      
        
        infoLabel.attributedText = centerText
    }
    @IBAction func linkTapped(_ sender: Any) {
        let url = URL(string: "https://www.mozilla.org/en-US/privacy/")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
