//
//  SettingsViewController.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/9/18.
//

import Foundation
import SafariServices
import UIKit

class SettingsViewController: SwipableTabViewController, SFSafariViewControllerDelegate {
    @IBOutlet fileprivate weak var mainTitleLabel: UILabel!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var scrollViewInner: UIView!
    @IBOutlet fileprivate var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var gradientButton: GradientButton!
    fileprivate let maxHeaderHeight: CGFloat = 44
    fileprivate let minHeaderHeight: CGFloat = 24
    fileprivate var previousScrollOffset: CGFloat = 0

    private var safariVC: SFSafariViewController?
    private var userDefaults: UserDefaults = UserDefaults()

    var keychainService: KeychainService!

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var articleAudioRateButton: UIButton!
    @IBOutlet weak var podcastAudioRateButton: UIButton!
    @IBOutlet weak var showRecommendedArticlesSwitch: UISwitch!
    @IBOutlet weak var sendUsageDataSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
    }

    // MARK: Private
    fileprivate func configureUI() {
        self.scrollView.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.tapFunction))
        infoLabel.isUserInteractionEnabled = true
        infoLabel.addGestureRecognizer(tap)

        gradientButton.direction = .horizontally(centered: 0.1)

        let rawCenterString: NSString = """
        Mozilla strives to only collect what we need to provide and improve Firefox Listen for everyone. Learn More.
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

        showRecommendedArticlesSwitch.isOn = userDefaults.bool(forKey: "showRecommendedArticles")
        sendUsageDataSwitch.isOn = userDefaults.bool(forKey: "sendUsageData")
        self.articleAudioRateButton.setTitle(
            String(format: "%.2fx", userDefaults.float(forKey: "articlePlaybackSpeed")), for: .normal)
        self.podcastAudioRateButton.setTitle(
            String(format: "%.2fx", userDefaults.float(forKey: "podcastPlaybackSpeed")), for: .normal)
    }

    @objc func tapFunction(sender: UITapGestureRecognizer) {
        self.openPrivacyPolicy()
    }

    private func openPrivacyPolicy() {
        guard let privacyURL = URL(string: "https://www.mozilla.org/en-US/privacy/") else {
            return //be safe
        }

        safariVC = SFSafariViewController(url: privacyURL)
        safariVC!.delegate = self
        self.present(safariVC!, animated: true, completion: nil)
    }

    @IBAction func articleAudioRateButtonTapped(_ sender: Any) {
        var current = self.userDefaults.float(forKey: "articlePlaybackSpeed")
        current += 0.25
        if current > 3.0 {
            current = 0.5
        }

        self.userDefaults.set(current, forKey: "articlePlaybackSpeed")

        DispatchQueue.main.async {
            self.articleAudioRateButton.setTitle(String(format: "%.2fx", current), for: .normal)
        }
    }

    @IBAction func podcastAudioRateButtonTapped(_ sender: Any) {
        var current = self.userDefaults.float(forKey: "podcastPlaybackSpeed")
        current += 0.25
        if current > 3.0 {
            current = 0.5
        }

        self.userDefaults.set(current, forKey: "podcastPlaybackSpeed")

        DispatchQueue.main.async {
            self.podcastAudioRateButton.setTitle(String(format: "%.2fx", current), for: .normal)
        }
    }

    @IBAction func showRecommendedArticlesValueChanged(_ sender: Any) {
        self.userDefaults.set(self.showRecommendedArticlesSwitch.isOn, forKey: "showRecommendedArticles")
    }

    @IBAction func enableSharingButtonTapped(_ sender: Any) {
    }

    @IBAction func sendUsageDataValueChanged(_ sender: Any) {
        self.userDefaults.set(self.sendUsageDataSwitch.isOn, forKey: "sendUsageData")
    }

    @IBAction func signOutButtonTapped(_ sender: Any) {
    }

    @IBAction func feedbackButtonTapped(_ sender: Any) {
        let recipient = "firefoxlisten@mozilla.com"
        let subject = "Firefox Listen Feedback".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url = URL(string: "mailto:\(recipient)?subject=\(subject)")!
        UIApplication.shared.open(url)
    }

    @IBAction func privacyNoticeButtonTapped(_ sender: Any) {
        self.openPrivacyPolicy()
    }
}

extension SettingsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset

            let absoluteTop: CGFloat = 0
            let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height

            let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
            let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom

            if self.canAnimateHeader(scrollView) {
                // Calculate new header height
                var newHeight = self.headerHeightConstraint.constant

                if isScrollingDown {
                    newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
                } else if isScrollingUp {
                    newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
                }

                // Header needs to animate
                if newHeight != self.headerHeightConstraint.constant {
                    self.headerHeightConstraint.constant = newHeight
                    self.updateHeader()
                    self.setScrollPosition(self.previousScrollOffset)
                }

                self.previousScrollOffset = scrollView.contentOffset.y
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }

    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)

        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }

    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight

        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }

    func collapseHeader() {
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.headerHeightConstraint.constant = self.minHeaderHeight
                        self.updateHeader()
                        self.view.layoutIfNeeded()
        })
    }

    func expandHeader() {
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.headerHeightConstraint.constant = self.maxHeaderHeight
                        self.updateHeader()
                        self.view.layoutIfNeeded()
        })
    }

    func setScrollPosition(_ position: CGFloat) {
        self.scrollView.contentOffset = CGPoint(x: self.scrollView.contentOffset.x, y: position)
    }

    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        let percentage = openAmount / range

        self.mainTitleLabel.alpha = percentage
    }
}
