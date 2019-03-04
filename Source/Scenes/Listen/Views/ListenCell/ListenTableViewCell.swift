//
//  ListenTableViewCell.swift
//  Scout
//
//

import UIKit
import DifferenceKit

class ListenTableViewCell: UITableViewCell {

    struct ViewModel: Differentiable {

        let itemId: String
        let imageUrl: URL?
        let iconUrl: URL?
        let publisher: String
        let title: String
        let duration: String
        let summary: String?
        let episode: String?


        var differenceIdentifier: String {
            return itemId
        }

        func isContentEqual(to source: ListenTableViewCell.ViewModel) -> Bool {
            return imageUrl == source.imageUrl &&
                iconUrl == source.iconUrl &&
                publisher == source.publisher &&
                title == source.title &&
                duration == source.duration &&
                summary == source.summary &&
                episode == source.episode
        }
    }

    var onSummaryAction: (() -> Void)?

    // MARK: Outlets
    
    @IBOutlet private weak var topicImageView: UIImageView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var publisherLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var summaryButton: UIButton!
    @IBOutlet private weak var episodeView: UIView!
    @IBOutlet private weak var episodLabel: UILabel!
    @IBOutlet private weak var insetConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUi()
    }

    func configure(_ state: ViewModel) {
        topicImageView.kf.setImage(with: state.imageUrl)
        topicImageView.kf.indicatorType = .activity

        iconImageView.kf.setImage(with: state.iconUrl)

        publisherLabel.text = state.publisher
        titleLabel.text = state.title
        timeLabel.text = state.duration

        if let summary = state.summary {
            summaryButton.isHidden = false
            summaryButton.setTitle(summary, for: .normal)
        } else {
            summaryButton.isHidden = true
        }

        if let episodeText = state.episode {
            episodLabel.text = episodeText
            episodeView.isHidden = false
        } else {
            episodeView.isHidden = true
        }
    }

    override func willTransition(to state: UITableViewCell.StateMask) {
        super.willTransition(to: state)

        if state.rawValue == 0 {
            //UIView.animate(withDuration: 1) {
                self.insetConstraint.constant = 0
                self.layoutIfNeeded()
            //}
        } else if state.rawValue == 1 {
            //UIView.animate(withDuration: 1) {
                self.insetConstraint.constant = 15
                self.layoutIfNeeded()
            //}
        }
    }

    // MARK: Actions

    @IBAction func summaryAction(_ sender: Any) {
        onSummaryAction?()
    }

}

// MARK: - Private
private extension ListenTableViewCell {

    func setupUi() {
        topicImageView.layer.masksToBounds = true
        iconImageView.layer.masksToBounds = true

        publisherLabel.textColor = UIColor.black
        publisherLabel.font = UIFont.sfProText(.light, ofSize: 12)

        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.sfProDisplay(.heavy, ofSize: 14)

        timeLabel.textColor = UIColor.black
        timeLabel.font = UIFont.sfProText(.regular, ofSize: 10)

        summaryButton.titleLabel?.font = UIFont.sfProText(.regular, ofSize: 10)
        summaryButton.titleLabel?.textColor = UIColor.fxAzureRadiance

        episodeView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        episodeView.layer.cornerRadius = 6
        episodeView.layer.masksToBounds = true

        episodLabel.textColor = UIColor.black
        episodLabel.font = UIFont.sfCompactText(.regular, ofSize: 9)
    }
}
