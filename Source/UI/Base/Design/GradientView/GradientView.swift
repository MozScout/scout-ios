//
//  GradientView.swift
//  Scout
//
//  Created by Shurupov Alex on 5/16/18.
//

import UIKit

class GradientView: UIView {
    var direction: GradientDirectionForView = .horizontal {
        didSet {
            gradientLayer.startPoint = direction.startPoint
            gradientLayer.endPoint = direction.endPoint
            gradientLayer.setNeedsDisplay()
        }
    }

    var alphaComponent: CGFloat = 1.0 {
        didSet {
            startColor = startColor.withAlphaComponent(alphaComponent)
            endColor = endColor.withAlphaComponent(alphaComponent)
        }
    }

    var startColor = Design.Color.purple {
        didSet { self.replace(startColor: startColor, endColor: endColor) }
    }

    var endColor = Design.Color.lightBlue {
        didSet { self.replace(startColor: startColor, endColor: endColor) }
    }

    override open class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }

    fileprivate var gradientLayer: CAGradientLayer {
        // swiftlint:disable:next force_cast
        return self.layer as! CAGradientLayer
    }

    // MARK: Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Private
    fileprivate func replace(startColor: UIColor, endColor: UIColor) {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.setNeedsDisplay()
    }

    fileprivate func configure() {
        self.gradientLayer.startPoint = self.direction.startPoint
        self.gradientLayer.endPoint = self.direction.endPoint
        self.gradientLayer.locations = [0.0, 1.5]
        self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
    }
}

enum GradientDirectionForView {
    static var horizontal: GradientDirectionForView { return .horizontally(centered: 1.0) }
    static var vertical: GradientDirectionForView { return .vertically(centered: 0.5) }

    // Value - relative offset gradient center. From 0.0 to 1.0
    case horizontally(centered: CGFloat)
    case vertically(centered: CGFloat)

    // Value - absolute position of gradient colors
    case custom(startPoint: CGPoint, endPoint: CGPoint)

    var startPoint: CGPoint {
        switch self {
            case .horizontally(let xCenter):
                let normalizedCenter = min(1.0, max(0.0, xCenter))
                return CGPoint(x: (normalizedCenter - 0.5), y: -0.4)
            case .vertically(let yCenter):
                let normalizedCenter = min(1.0, max(0.0, yCenter))
                return CGPoint(x: 0.0, y: (normalizedCenter - 0.5))
            case .custom(let startPoint, _):
                return startPoint
        }
    }

    var endPoint: CGPoint {
        switch self {
            case .horizontally:
                return CGPoint(x: 1.0, y: 0.0)
            case .vertically:
                return CGPoint(x: 0.0, y: 1.0)
            case .custom(_, let endPoint):
                return endPoint
        }
    }
}
