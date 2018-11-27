//
//  AddPodcastsCollectionViewCell.swift
//  Scout
//
//  Created by alegero on 10/9/18.
//  Copyright © 2018 NIX. All rights reserved.
//

import UIKit

class AddPodcastsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var indicatorButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func indicatorButtonTapped(_ sender: Any) {
        if indicatorButton.isSelected == true {
            indicatorButton.isSelected = false
        } else {
            indicatorButton.isSelected = true
        }
    }

    func configureCell(_ imageUrl: String) {
        imageView.downloadImageFrom(link: imageUrl, contentMode: .scaleAspectFit)
    }
}
