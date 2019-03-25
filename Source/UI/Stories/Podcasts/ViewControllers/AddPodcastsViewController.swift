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

        switch indexPath.item {
            case 0:
                // swiftlint:disable:next line_length
                cell.configureCell("https://media.npr.org/assets/img/2018/08/06/npr_witw_podcasttile_sq-2fdc0ec2ec9d937e93684318fcc0b90042db2605-s400-c85.jpg")
            case 1:
                // swiftlint:disable:next line_length
                cell.configureCell("https://static01.nyt.com/images/2017/01/29/podcasts/the-daily-album-art/the-daily-album-art-thumbLarge-v4.jpg")
            case 2:
                cell.configureCell("https://99percentinvisible.org/app/themes/invisible/dist/images/99pi_logo_text.png")
            case 3:
                // swiftlint:disable:next line_length
                cell.configureCell("https://res-4.cloudinary.com/gimlet-media/image/upload/f_auto,q_auto:best/beqfhc1um2sktkc5pw9k")
            case 4:
                // swiftlint:disable:next line_length
                cell.configureCell("https://media.npr.org/assets/img/2018/08/06/npr_wwdtm_podcasttile_sq-1e9edf5dfb49a3fff3703764e39442173ba8558a-s400-c85.jpg")
            default:
                break
        }

        return cell
    }
}
