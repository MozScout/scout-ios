//
//  PlayMyListViewController.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/9/18.
//

import Foundation
import UIKit

protocol PlayListDelegate: class {
    func openPlayerFromMain(withModel: ScoutArticle, isFullArticle: Bool)
}

class PlayMyListViewController: UIViewController, PlayMyListTableViewCellDelegate {
    
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
    fileprivate var spinner:UIActivityIndicatorView?
    fileprivate var articleNumber: Int = 0
    var scoutClient : ScoutHTTPClient!
    var keychainService : KeychainService!
    var userID : String = ""
    fileprivate var scoutTitles : [ScoutArticle]? = nil
    var expandedRows = Set<Int>()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
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
            keychainService.save(value: userID, key: "userID")
        }
        gradientButton.direction = .horizontally(centered: 0.1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PlayMyListTableViewCell", bundle: nil), forCellReuseIdentifier: cellRowReuseId)
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0);
    }
    
    fileprivate func getScoutTitles() {
        scoutClient.getScoutTitles(withCmd: "ScoutTitles", userid: userID, successBlock: { (titles) in
            self.scoutTitles = titles
            DispatchQueue.main.async {
                self.hideHUD()
                self.tableView.reloadData()
            }
        }, failureBlock: { (failureResponse, error, response) in
            self.showAlert(errorMessage: "Unable to get your articles at this time, please check back later")
            self.hideHUD()
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
                guard let requiredDelegate = self.playerDelegateFromMain else { return }
                requiredDelegate.openPlayerFromMain(withModel: scoutArticle, isFullArticle: true)
                self.hideHUD()
            }
        }, failureBlock: { (failureResponse, error, response) in
            self.showAlert(errorMessage: "Unable to get your articles at this time, please check back later")
            self.hideHUD()
        })
    }
    
    func skimButtonTapped() {
        showHUD()
        self.scoutClient.getSummaryLink(userid: userID, url: (self.scoutTitles![articleNumber].resolvedURL?.absoluteString)!, successBlock: { (scoutArticle) in
            DispatchQueue.main.async {
                if scoutArticle.resolvedURL != nil {
                    guard let requiredDelegate = self.playerDelegateFromMain else { return }
                    requiredDelegate.openPlayerFromMain(withModel: scoutArticle, isFullArticle: false)
                    self.hideHUD()
                }
                else {
                    self.showAlert(errorMessage: "Skim version is not available")
                    self.hideHUD()
                }
            }
        }, failureBlock: { (failureResponse, error, response) in
            self.showAlert(errorMessage: "Unable to get your articles at this time, please check back later")
            self.hideHUD()
        })
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getScoutTitles()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
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
        
        tableView.scrollToRow(at: indexPath, at: .none, animated: false)
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
    
    private func showAlert(errorMessage: String) -> Void {
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
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
