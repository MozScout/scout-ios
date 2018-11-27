//
//  PodcastsCollectionViewCell.swift
//  Scout
//
//

import Kingfisher
import UIKit

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

    func configureCell(_ model: ScoutArticle) {
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        imageView.downloadImageFrom(link: model.articleImageURL!.absoluteString, contentMode: .scaleAspectFit)

        let formatterIn = DateFormatter()
        formatterIn.dateFormat = "yyyy-MM-dd"
        let formatterOut = DateFormatter()
        formatterOut.dateFormat = "MMM d"
        dateLabel.text = formatterOut.string(from: formatterIn.date(from: model.latestEpisode!.0)!)

        titleLabel.text = model.latestEpisode!.1
    }
}
