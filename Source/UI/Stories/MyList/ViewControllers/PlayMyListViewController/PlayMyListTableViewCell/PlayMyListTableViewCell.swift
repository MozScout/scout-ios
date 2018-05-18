//
//  PlayMyListTableViewCell.swift
//  Scout
//
//  Created by Shurupov Alex on 5/16/18.
//

import UIKit

class PlayMyListTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var resourceImage: UIImageView!
    @IBOutlet weak var resourceName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var lengthMinutes: UILabel!
    @IBOutlet weak var skimMinutes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(withModel model: ScoutArticle) {
        resourceName.text = model.author
        title.text = model.title
        lengthMinutes.text = String(format: "%@ mins", String(describing: model.lengthMinutes))
    }
}
