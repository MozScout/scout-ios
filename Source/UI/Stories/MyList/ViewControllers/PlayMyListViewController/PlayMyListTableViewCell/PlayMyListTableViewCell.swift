//
//  PlayMyListTableViewCell.swift
//  Scout
//
//  Created by Shurupov Alex on 5/16/18.
//

import UIKit
protocol PlayMyListTableViewCellDelegate: class {
    // maybe need send also several button states
    func playButtonTapped()
    func skimButtonTapped()
    func archiveButtonTapped()
}

class PlayMyListTableViewCell: UITableViewCell {
    
    weak var playButtonDelegate: PlayMyListTableViewCellDelegate?
    weak var skimButtonDelegate: PlayMyListTableViewCellDelegate?
    weak var archiveButtonDelegate : PlayMyListTableViewCellDelegate?
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
    var isExpanded:Bool = false
    {
        didSet
        {
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
            self.mainImage.downloadImageFrom(link: (model.articleImageURL?.absoluteString)! , contentMode: .scaleAspectFill)
        }
        else {
            self.mainImage.image = UIImage(named: "mainImg")
        }
        
        if model.icon_url != URL(string: "") {
            self.publisherImage.downloadImageFrom(link: (model.icon_url?.absoluteString)! , contentMode: .scaleToFill)
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
}
