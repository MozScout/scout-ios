//
//  MyListTableViewCell.swift
//  Scout
//
//  Created by Shurupov Alex on 5/16/18.
//

import Kingfisher
import UIKit

protocol MyListTableViewCellDelegate: class {
    // maybe need send also several button states
    func playButtonTapped()
    func skimButtonTapped()
    func archiveButtonTapped()
}

class MyListTableViewCell: UITableViewCell {
    weak var playButtonDelegate: MyListTableViewCellDelegate?
    weak var skimButtonDelegate: MyListTableViewCellDelegate?
    weak var archiveButtonDelegate: MyListTableViewCellDelegate?
    @IBOutlet weak var publisherImage: UIImageView!
    @IBOutlet weak var horizontalLine: UIView!
    @IBOutlet weak var verticalLine: UIView!
    @IBOutlet weak var expandedView: UIView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var resourceName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var lengthMinutes: UILabel!
    @IBOutlet weak var expandedViewHeight: NSLayoutConstraint!

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var skimButton: UIButton!
    var isExpanded: Bool = false {
        didSet {
            if !isExpanded {
                self.doneButton.isHidden = true
                self.playButton.isHidden = true
                self.skimButton.isHidden = true
                self.expandedViewHeight.constant = 0.0
            } else {
                self.doneButton.isHidden = false
                self.playButton.isHidden = false
                self.skimButton.isHidden = false
                self.expandedViewHeight.constant = 45.0
            }
        }
    }

    func configureCell(withModel model: ScoutArticle) {
        self.isExpanded = false
        horizontalLine.backgroundColor = UIColor(rgb: 0xEDEDF0)
        verticalLine.backgroundColor = UIColor(rgb: 0xEDEDF0)
        expandedView.backgroundColor = UIColor(rgb: 0x45A1FF)
        resourceName.text = model.publisher
        title.text = model.title
        lengthMinutes.text = String(format: "%@ mins", String(describing: model.lengthMinutes))

        if model.articleImageURL != URL(string: "") {
            mainImage.kf.setImage(with: model.articleImageURL)
        } else {
            self.mainImage.image = UIImage(named: "mainImg")
        }

        if model.iconURL != URL(string: "") {
            publisherImage.kf.setImage(with: model.iconURL)
        }

        if model.isPodcast {
            self.publisherImage.isHidden = true
            self.resourceName.isHidden = true
            self.skimButton.setTitle("Episodes", for: .normal)
            self.doneButton.setImage( UIImage(named: "deleteButton"), for: .normal)
        }
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        guard let requiredDelegate = playButtonDelegate else { return }
        requiredDelegate.playButtonTapped()
    }
    @IBAction func skimButtonTapped(_ sender: Any) {
        guard let requiredDelegate = skimButtonDelegate else { return }
        requiredDelegate.skimButtonTapped()
    }
    @IBAction func archiveButtonTapped(_ sender: Any) {
        guard let requiredDelegate = archiveButtonDelegate else { return }
        requiredDelegate.archiveButtonTapped()
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }
}
