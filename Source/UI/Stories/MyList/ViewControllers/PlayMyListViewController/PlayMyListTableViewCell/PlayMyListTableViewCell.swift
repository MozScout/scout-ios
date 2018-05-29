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
    
    func configureCell(withModel model: ScoutArticle) {
        resourceName.text = model.author
        title.text = model.title
        lengthMinutes.text = String(format: "%@ mins", String(describing: model.lengthMinutes))
        if model.articleImageURL != URL(string: "") {
            
            if let data = try? Data(contentsOf: model.articleImageURL!)
            {
                let image: UIImage = UIImage(data: data)!
                self.mainImage.image = image
            }
        }
        
    }
}
