//
//  PodcastsCollectionViewCell.swift
//  Scout
//
//

import UIKit
import Kingfisher

struct PodcastModel {
    var date: String
    var subTitle: String
    var url: URL
}

class PodcastsCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

    func configureCell(with model: PodcastModel) {
       
    }
}
