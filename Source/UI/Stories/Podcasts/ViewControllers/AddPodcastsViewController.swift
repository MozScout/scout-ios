//
//  AddPodcastsViewController.swift
//  Scout
//
//  Created by alegero on 10/9/18.
//  Copyright © 2018 NIX. All rights reserved.
//

import UIKit

class AddPodcastsViewController: UIViewController {
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var gradientButton: GradientButton!
    @IBOutlet weak var collectionView: UICollectionView!
    private let collectionRowReuseId = "collectionCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    private func configureUI() {
        subscribeButton.backgroundColor = UIColor(red: 0 / 255, green: 96 / 255, blue: 223 / 255, alpha: 1.0)
        subscribeButton.layer.cornerRadius = 8.0
        gradientButton.direction = .horizontally(centered: 0.1)

        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AddPodcastsCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: collectionRowReuseId)
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddPodcastsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionRowReuseId,
                                                      // swiftlint:disable:next force_cast
                                                      for: indexPath) as! AddPodcastsCollectionViewCell

        return cell
    }

}
