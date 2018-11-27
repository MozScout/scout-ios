//
//  AboutCell.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Stanislav Ostrovskiy on 5/21/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

class AboutCell: UITableViewCell {
    @IBOutlet weak var aboutLabel: UILabel?
    @IBOutlet weak var icon: UIImageView?
    @IBOutlet weak var websiteButton: UIButton?
    @IBOutlet weak var categoryButton: UIButton?

    var website: URL?

    var item: PodcastDetailsViewModelItem? {
        didSet {
            guard  let item = item as? PodcastDetailsViewModelAboutItem else {
                return
            }
            self.aboutLabel?.text = item.about
            self.icon?.image = item.image
            self.categoryButton?.setTitle(item.category, for: .normal)
            self.website = item.website
        }
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }

    @IBAction func websiteButtonTapped(_ sender: Any) {
        if let url = self.website {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(
                    url,
                    options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
                    completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    @IBAction func categoryButtonTapped(_ sender: Any) {
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(
    _ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(
        uniqueKeysWithValues: input.map { key, value in
            (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)
        }
    )
}
