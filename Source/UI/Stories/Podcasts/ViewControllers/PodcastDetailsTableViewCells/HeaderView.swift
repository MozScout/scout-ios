//
//  HeaderView.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Stanislav Ostrovskiy on 5/21/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func toggleSection(header: HeaderView, section: Int)
}

class HeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var backChevronButton: UIButton!
    var item: PodcastDetailsViewModelItem? {
        didSet {
            guard let item = item else {
                return
            }

            titleLabel?.text = item.sectionTitle
            setCollapsed(collapsed: item.isCollapsed)
            self.backgroundView = UIView(frame: self.bounds)
            self.backgroundView?.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        }
    }

    @IBOutlet weak var titleLabel: UILabel?

    var section: Int = 0

    weak var delegate: HeaderViewDelegate?

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }

    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }

    func setCollapsed(collapsed: Bool) {
        backChevronButton?.rotate(collapsed ? 0.0 : .pi)
    }
}

extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")

        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards

        self.layer.add(animation, forKey: nil)
    }
}
