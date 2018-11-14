//
//  MyListViewController.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/9/18.
//

import Foundation
import UIKit

protocol PlayListDelegate: class {
    func pause()
    func stop()
    func resume()
    func openPlayerFromMain(withModel: ScoutArticle, isFullArticle: Bool)
}

class MyListViewController: UIViewController, MyListTableViewCellDelegate, SBSpeechRecognizerDelegate {
    @IBOutlet fileprivate weak var mainTitleLabel: UILabel!
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var gradientButton: GradientButton!

    weak var playerDelegateFromMain: PlayListDelegate?
    fileprivate let maxHeaderHeight: CGFloat = 44
    fileprivate let minHeaderHeight: CGFloat = 24
    fileprivate var previousScrollOffset: CGFloat = 0
    fileprivate let cellRowReuseId = "cellrow"
    fileprivate var spinner: UIActivityIndicatorView?
    fileprivate var articleNumber: Int = 0

    var selectedIndex = IndexPath()
    var scoutClient: ScoutHTTPClient!
    var keychainService: KeychainService!
    var speechService: SpeechService!
    var userID: String = ""
    fileprivate var scoutTitles: [ScoutArticle]?
    var expandedRows = Set<Int>()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black

        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
        self.getScoutTitles()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.headerHeightConstraint.constant = self.maxHeaderHeight
        updateHeader()
    }

    // MARK: Private
    fileprivate func configureUI() {
        spinner = self.addSpinner()
        tableView.addSubview(self.refreshControl)
        self.showHUD()
        if keychainService.value(for: "userID") == nil {
            _ = keychainService.save(value: userID, key: "userID")
        }
        gradientButton.direction = .horizontally(centered: 0.1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyListTableViewCell", bundle: nil),
                           forCellReuseIdentifier: cellRowReuseId)
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        // tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.bottomLayoutGuide.length, right: 0)
    }

    fileprivate func getScoutTitles() {
        scoutClient.getScoutTitles(withCmd: "ScoutTitles",
                                   userid: userID,
                                   successBlock: { (titles) in
                                       self.scoutTitles = titles
                                       DispatchQueue.main.async {
                                           self.hideHUD()
                                           self.tableView.reloadData()
                                       }
                                   }, failureBlock: { (_, _, _) in
                                       self.showAlert(errorMessage: """
                                                      Unable to get your articles at this time, please check back \
                                                      later
                                                      """)
                                       self.hideHUD()
                                   })
    }

    func addSpinner() -> UIActivityIndicatorView {
        // Adding spinner over launch screen
        let spinner = UIActivityIndicatorView.init()
        spinner.style = UIActivityIndicatorView.Style.whiteLarge
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)

        let xConstraint = NSLayoutConstraint(item: spinner,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self.view,
                                             attribute: .centerX,
                                             multiplier: 1,
                                             constant: 0)
        let yConstraint = NSLayoutConstraint(item: spinner,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: self.view,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant: 0)

        NSLayoutConstraint.activate([xConstraint, yConstraint])

        self.view.bringSubviewToFront(spinner)

        return spinner
    }

    func showHUD() {
        DispatchQueue.main.async {
            self.spinner?.startAnimating()
            self.tableView.isUserInteractionEnabled = false
        }
    }

    func hideHUD() {
        DispatchQueue.main.async {
            self.spinner?.stopAnimating()
            self.tableView.isUserInteractionEnabled = true
        }
    }

    func playButtonTapped() {
        showHUD()
        _ = self.scoutClient.getArticleLink(userid: userID,
                                            url: (self.scoutTitles![articleNumber].resolvedURL?.absoluteString)!,
                                            successBlock: { (scoutArticle) in
                                                DispatchQueue.main.async {
                                                    guard let requiredDelegate = self.playerDelegateFromMain else {
                                                        return
                                                    }
                                                    requiredDelegate.openPlayerFromMain(withModel: scoutArticle,
                                                                                        isFullArticle: true)
                                                    self.hideHUD()
                                                }
                                            }, failureBlock: { (_, _, _) in
                                                self.showAlert(errorMessage: """
                                                               Unable to get your articles at this time, please check \
                                                               back later
                                                               """)
                                                self.hideHUD()
                                            })
    }

    func skimButtonTapped() {
        showHUD()
        _ = self.scoutClient.getSummaryLink(userid: userID,
                                            url: (self.scoutTitles![articleNumber].resolvedURL?.absoluteString)!,
                                            successBlock: { (scoutArticle) in
                                                DispatchQueue.main.async {
                                                    if scoutArticle.resolvedURL != nil {
                                                        guard let requiredDelegate = self.playerDelegateFromMain else {
                                                            return
                                                        }
                                                        requiredDelegate.openPlayerFromMain(withModel: scoutArticle,
                                                                                            isFullArticle: false)
                                                        self.hideHUD()
                                                    } else {
                                                        self.showAlert(errorMessage: "Skim version is not available")
                                                        self.hideHUD()
                                                    }
                                                }
                                            }, failureBlock: { (_, _, _) in
                                                self.showAlert(errorMessage: """
                                                               Unable to get your articles at this time, please check \
                                                               back later
                                                               """)
                                                self.hideHUD()
                                            })
    }

    func archiveButtonTapped() {
        _ = self.scoutClient.archiveScoutTitle(withCmd: "Archive",
                                               userid: userID,
                                               itemid: self.scoutTitles![articleNumber].itemID,
                                               successBlock: {
                                                   self.scoutTitles!.remove(at: self.articleNumber)
                                                   let indexPath = IndexPath(row: self.articleNumber, section: 0)
                                                   DispatchQueue.main.async {
                                                       self.tableView.beginUpdates()
                                                       self.tableView.deleteRows(at: [indexPath], with: .fade)
                                                       self.selectedIndex = []
                                                       self.tableView.endUpdates()
                                                   }
                                               }, failureBlock: { (_, _, _) in
                                                   self.showAlert(errorMessage: """
                                                                  Unable to get your articles at this time, please \
                                                                  check back later
                                                                  """)
                                                   self.hideHUD()
                                               })
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getScoutTitles()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    func beginWakeWordDetector() {
        self.speechService.delegate = self
        self.speechService.beginWakeWordDetector()
    }

    func speechRecognitionFinished(transcription: String) {
        print("speechRecognitionFinished(): \(transcription)")
        switch transcription {
            case "Play", "Resume":
                self.resume()
            case "Pause":
                self.pause()
            case "Stop":
                self.stop()
            default:
                print("Unhandled command: \(transcription)")
        }
        /*
         if self.console.text.range(of: "Skim ") != nil {
         self.console.text.removeSubrange(self.console.text.range(of: "Skim ")!)
         self.getSkimURL(withSearchTerm: self.console.text)
         } else if self.console.text.range(of: "Skim that article about ") != nil {
         self.console.text.removeSubrange(self.console.text.range(of: "Skim that article about ")!)
         self.getSkimURL(withSearchTerm: self.console.text)
         } else if self.console.text.range(of: "Skim that article ") != nil {
         self.console.text.removeSubrange(self.console.text.range(of: "Skim that article ")!)
         self.getSkimURL(withSearchTerm: self.console.text)
         } else if self.console.text.range(of: "Skim article about ") != nil {
         self.console.text.removeSubrange(self.console.text.range(of: "Skim article about ")!)
         self.getSkimURL(withSearchTerm: self.console.text)
         } else if self.console.text.range(of: "Play that article about ") != nil {
         self.console.text.removeSubrange(self.console.text.range(of: "Play that article about ")!)
         self.getURL(withSearchTerm: self.console.text)
         } else if self.console.text.range(of: "Play article about ") != nil {
         self.console.text.removeSubrange(self.console.text.range(of: "Play article about ")!)
         self.getURL(withSearchTerm: self.console.text)
         } else if self.console.text.range(of: "Play that article ") != nil {
         self.console.text.removeSubrange(self.console.text.range(of: "Play that article ")!)
         self.getURL(withSearchTerm: self.console.text)
         } else if self.console.text.range(of: "Play ") != nil {
         self.console.text.removeSubrange(self.console.text.range(of: "Play ")!)
         self.getURL(withSearchTerm: self.console.text)
         } else if self.console.text.range(of: "Scout that article about ") != nil {
         self.console.text.removeSubrange(self.console.text.range(of: "Scout that article about ")!)
         self.getURL(withSearchTerm: self.console.text)
         } else if self.console.text.range(of: "Scout article about ") != nil {
         self.console.text.removeSubrange(self.console.text.range(of: "Scout article about ")!)
         self.getURL(withSearchTerm: self.console.text)
         } else if self.console.text.range(of: "Scout that article ") != nil {
         self.console.text.removeSubrange(self.console.text.range(of: "Scout that article ")!)
         self.getURL(withSearchTerm: self.console.text)
         } else {
         if self.console.text.range(of: "Scout ") != nil {
         self.console.text.removeSubrange(self.console.text.range(of: "Scout ")!)
         self.getURL(withSearchTerm: self.console.text)
         } else {
         self.getURL(withSearchTerm: self.console.text)
         }
         }
         */
        self.speechService.beginWakeWordDetector()
    }

    func speechRecognitionPartialResult(transcription: String) {
        // print("speechRecognitionPartialResult(): \(transcription)")
    }

    func wakeWordDetected() {
        print("wakeWordDetected()")
        self.speechService.startRecording()
    }

    private func pause() {
        DispatchQueue.main.async {
            guard let requiredDelegate = self.playerDelegateFromMain else {
                return
            }
            requiredDelegate.pause()
        }
    }

    private func stop() {
        DispatchQueue.main.async {
            guard let requiredDelegate = self.playerDelegateFromMain else {
                return
            }
            requiredDelegate.stop()
        }
    }

    private func resume() {
        DispatchQueue.main.async {
            guard let requiredDelegate = self.playerDelegateFromMain else {
                return
            }
            requiredDelegate.resume()
        }
    }
}

extension MyListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.scoutTitles != nil {
            return self.scoutTitles!.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellRowReuseId,
                                                 // swiftlint:disable:next force_cast
                                                 for: indexPath) as! MyListTableViewCell

        self.selectedIndex = []
        cell.playButtonDelegate = self
        cell.skimButtonDelegate = self
        cell.archiveButtonDelegate = self
        cell.configureCell(withModel: self.scoutTitles![indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MyListTableViewCell

            else { return }

        if cell.isExpanded {
            self.expandedRows.remove(indexPath.row)
            selectedIndex = []
        } else {
            self.expandedRows.insert(indexPath.row)
            articleNumber = indexPath.row
            selectedIndex = indexPath
        }

        cell.isExpanded = !cell.isExpanded

        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndex {
            return 145.0
        }
        return 100.0
    }
}

extension MyListViewController: UITableViewDelegate {
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
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }

    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        let percentage = openAmount / range

        self.mainTitleLabel.alpha = percentage
    }

    private func showAlert(errorMessage: String) {
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style {
                case .default:
                    print("ok")

                case .cancel:
                    print("cancel")

                case .destructive:
                    print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}
