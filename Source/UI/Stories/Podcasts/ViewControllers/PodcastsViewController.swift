//
//  PodcastsViewController.swift
//  Scout
//
//

import UIKit

protocol PodcastsDelegate: class {
    func openPodcastDetails()
    func openAddPodcasts()
}

class PodcastsViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var gradientButton: GradientButton!
    weak var podcastsDelegate: PodcastsDelegate?
    private var spinner : UIActivityIndicatorView?
    private let cellRowReuseId = "cellrow"
    private let collectionRowReuseId = "collectionCell"
    private var scoutTitles: [ScoutArticle]? = [
        ScoutArticle(withArticleID: "12", title: "Test", author: "Test", lengthMinutes: 5, sortID: 4, resolvedURL: nil, articleImageURL: nil, url: "", publisher: "", icon_url: nil),
        ScoutArticle(withArticleID: "12", title: "Test2", author: "Test2", lengthMinutes: 5, sortID: 4, resolvedURL: nil, articleImageURL: nil, url: "", publisher: "", icon_url: nil)]
    var scoutClient : ScoutHTTPClient!
    var keychainService : KeychainService!
    
    var selectedIndex = IndexPath()
    var userID : String = ""
    var expandedRows = Set<Int>()
    fileprivate var articleNumber: Int = 0
    
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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: Private
    fileprivate func configureUI() {
        spinner = self.addSpinner()
        tableView.addSubview(self.refreshControl)

        gradientButton.direction = .horizontally(centered: 0.1)
        tableView.dataSource = self
        collectionView.dataSource = self
        tableView.register(UINib(nibName: "PlayMyListTableViewCell", bundle: nil), forCellReuseIdentifier: cellRowReuseId)
        collectionView.register(UINib(nibName: "PodcastsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionRowReuseId)
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0);
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

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    @IBAction func addPodcastsButtonTapped(_ sender: Any) {
        guard let requiredDelegate = self.podcastsDelegate else { return }
        requiredDelegate.openAddPodcasts()
    }
}

extension PodcastsViewController: UITableViewDataSource, UITableViewDelegate, PlayMyListTableViewCellDelegate {
    func playButtonTapped() {
        
    }
    
    func skimButtonTapped() {
        guard let requiredDelegate = self.podcastsDelegate else { return }
        requiredDelegate.openPodcastDetails()
    }
    
    func archiveButtonTapped() {
        
    }

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
        
        self.selectedIndex = []
        cell.playButtonDelegate = self
        cell.skimButtonDelegate = self
        cell.archiveButtonDelegate = self
        cell.configureCell(withModel: self.scoutTitles![indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PlayMyListTableViewCell
            
            else { return }
        
        switch cell.isExpanded {
        case true:
            self.expandedRows.remove(indexPath.row)
            selectedIndex = []
        case false:
            self.expandedRows.insert(indexPath.row)
            articleNumber = indexPath.row
            selectedIndex = indexPath
        }
        
        cell.isExpanded = !cell.isExpanded
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
    }
}

extension PodcastsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionRowReuseId, for: indexPath) as! PodcastsCollectionViewCell
        cell.configureCell()
        return cell
    }

}

