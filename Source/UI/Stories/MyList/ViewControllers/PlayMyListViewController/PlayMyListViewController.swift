//
//  PlayMyListViewController.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/9/18.
//

import Foundation
import UIKit

protocol PlayListDelegate: class {
    func openPlayer(withModel: ScoutArticle, isFullArticle: Bool)
}

class PlayMyListViewController: UIViewController, PlayMyListTableViewCellDelegate {
    
    @IBOutlet fileprivate weak var mainTitleLabel: UILabel!
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var gradientButton: GradientButton!
    
    weak var playerDelegate: PlayListDelegate?
    fileprivate let maxHeaderHeight: CGFloat = 64
    fileprivate let minHeaderHeight: CGFloat = 24
    fileprivate var previousScrollOffset: CGFloat = 0
    fileprivate let cellRowReuseId = "cellrow"
    fileprivate var spinner:UIActivityIndicatorView?
    fileprivate var articleNumber: Int = 0
    var scoutClient : ScoutHTTPClient!
    var keychainService : KeychainService!
    var userID : String = ""
    fileprivate var scoutTitles : [ScoutArticle]? = nil
    var expandedRows = Set<Int>()

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
        self.showHUD()
        if keychainService.value(for: "userID") == nil {
            keychainService.save(value: userID, key: "userID")
        }
        gradientButton.direction = .horizontally(centered: 0.1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PlayMyListTableViewCell", bundle: nil), forCellReuseIdentifier: cellRowReuseId)
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    fileprivate func getScoutTitles() {
        scoutClient.getScoutTitles(withCmd: "ScoutTitles", userid: userID, successBlock: { (titles) in
            self.scoutTitles = titles
            DispatchQueue.main.async {
                self.hideHUD()
                self.tableView.reloadData()
            }
        }, failureBlock: { (failureResponse, error, response) in
            
        })
    }
    
    
    func addSpinner() -> UIActivityIndicatorView {
        // Adding spinner over launch screen
        let spinner = UIActivityIndicatorView.init()
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        
        let xConstraint = NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        
        self.view.bringSubview(toFront: spinner)
        
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
        self.scoutClient.getArticleLink(userid: userID, url: (self.scoutTitles![articleNumber].resolvedURL?.absoluteString)!, successBlock: { (scoutArticle) in
            DispatchQueue.main.async {
                guard let requiredDelegate = self.playerDelegate else { return }
                requiredDelegate.openPlayer(withModel: scoutArticle, isFullArticle: true)
                self.hideHUD()
            }
        }, failureBlock: { (failureResponse, error, response) in
        })
    }
    
    func skimButtonTapped() {
        showHUD()
        self.scoutClient.getSummaryLink(userid: userID, url: (self.scoutTitles![articleNumber].resolvedURL?.absoluteString)!, successBlock: { (scoutArticle) in
            DispatchQueue.main.async {
                guard let requiredDelegate = self.playerDelegate else { return }
                requiredDelegate.openPlayer(withModel: scoutArticle, isFullArticle: false)
                self.hideHUD()
            }
        }, failureBlock: { (failureResponse, error, response) in
        })
    }
}

extension PlayMyListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.scoutTitles != nil {
            return self.scoutTitles!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellRowReuseId, for: indexPath) as! PlayMyListTableViewCell
        
        cell.playButtonDelegate = self
        cell.skimButtonDelegate = self
        cell.configureCell(withModel: self.scoutTitles![indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? PlayMyListTableViewCell
            
            else { return }
        
        switch cell.isExpanded {
        case true:
            self.expandedRows.remove(indexPath.row)
        case false:
            self.expandedRows.insert(indexPath.row)
            articleNumber = indexPath.row
        }
        
        cell.isExpanded = !cell.isExpanded
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PlayMyListTableViewCell
            else { return }
        
        self.expandedRows.remove(indexPath.row)
        
        cell.isExpanded = false
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

extension PlayMyListViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        
            let absoluteTop: CGFloat = 0
            let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
            let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
            let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
            if self.canAnimateHeader(scrollView) {
            
                // Calculate new header height
                var newHeight = self.headerHeightConstraint.constant
            
                if isScrollingDown {
                    newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
                }
                else if isScrollingUp {
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
        }
        else {
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
}
