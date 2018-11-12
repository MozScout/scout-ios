//
//  PodcastDetailsViewController.swift
//  Scout
//
//  Created by alegero on 10/3/18.
//  Copyright © 2018 NIX. All rights reserved.
//

import UIKit

class PodcastDetailsViewController: UIViewController {
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    fileprivate let viewModel = PodcastDetailsViewModel()
    private let cellRowReuseId = "cellrow"
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        subscribeButton.backgroundColor = UIColor(red: 0 / 255, green: 96 / 255, blue: 223 / 255, alpha: 1.0)
        subscribeButton.layer.cornerRadius = 8.0
        subscribeButton.clipsToBounds = true
        viewModel.reloadSections = { [weak self] (section: Int) in
            self?.tableView?.beginUpdates()
            self?.tableView?.reloadSections([section], with: .fade)
            self?.tableView?.endUpdates()
        }

        tableView?.estimatedRowHeight = 500
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.sectionHeaderHeight = 30
        tableView?.separatorStyle = .none
        tableView?.dataSource = viewModel
        tableView?.delegate = viewModel
        tableView?.register(AboutCell.nib, forCellReuseIdentifier: AboutCell.identifier)
        tableView.register(UINib(nibName: "PlayMyListTableViewCell", bundle: nil),
                           forCellReuseIdentifier: cellRowReuseId)
        tableView?.register(HeaderView.nib, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
