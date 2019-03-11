//
//  RoundTopicCell.swift
//  Scout
//
//

import UIKit
import DifferenceKit

class RoundTopicCell: UICollectionViewCell {

    struct ViewModel: Differentiable, Equatable {
        let topicId: String
        let title: String
        let imageUrl: URL?
        let isSelected: Bool

        var differenceIdentifier: String {
            return topicId
        }

        func isContentEqual(to source: RoundTopicCell.ViewModel) -> Bool {
            return self == source
        }
    }

    // MARK: Outlets

    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var checkMarkImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: Private Properties

    private let maskLayer = CAShapeLayer()
    private let borderLayer = CAGradientLayer()
    private let borderMaskLayer = CAShapeLayer()

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUi()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutShapeLayer()
    }

    func configure(_ state: ViewModel) {
        titleLabel.text = state.title
        imageView.kf.setImage(with: state.imageUrl, placeholder: #imageLiteral(resourceName: "Placeholder"))
        imageView.kf.indicatorType = .activity

        if state.isSelected {
            borderMaskLayer.lineWidth = 6
            borderLayer.colors = [UIColor.fxGreen.cgColor, UIColor.fxGreen.cgColor]
            checkMarkImageView.isHidden = false
        } else {
            borderMaskLayer.lineWidth = 3
            borderLayer.colors = [UIColor.fxRadicalRed.cgColor, UIColor.fxYellowOrange.cgColor]
            checkMarkImageView.isHidden = true
        }
    }
}

// MARK: - Private
private extension RoundTopicCell {

    var circlePath: CGPath? {
        let arcCenter = maskLayer.position
        let radius = maskLayer.bounds.size.width / 2
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * .pi
        let clockwise = true

        return UIBezierPath(
            arcCenter: arcCenter,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
            ).cgPath
    }

    func setupUi() {
        titleLabel.font = UIFont.sfProText(.bold, ofSize: 12)
        titleLabel.textColor = UIColor.black

        checkMarkImageView.image = UIImage(named: "onboardingCheckMark")

        maskLayer.fillColor = UIColor.black.cgColor
        imageView.layer.mask = maskLayer
        imageView.layer.masksToBounds = true

        borderMaskLayer.fillColor = nil
        borderMaskLayer.strokeColor = UIColor.black.cgColor

        borderLayer.mask = borderMaskLayer
        imageView.layer.addSublayer(borderLayer)
    }

    func layoutShapeLayer() {
        let frame = CGRect(
            origin: contentView.bounds.origin,
            size: CGSize(
                width: contentView.bounds.width,
                height: contentView.bounds.width
            )
        )

        maskLayer.frame = frame
        borderLayer.frame = frame
        borderMaskLayer.frame = frame

        maskLayer.path = circlePath
        borderMaskLayer.path = circlePath
    }
}
