//
//  GradientButton.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/9/18.
//

import Foundation
import UIKit

class GradientButton: UIButton {

    var direction: GradientDirection = .horizontal {
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

    override open var isHighlighted: Bool {
        didSet { if isHighlighted != oldValue { self.reload() } }
    }

    override open var isSelected: Bool {
        didSet { if isSelected != oldValue { self.reload() } }
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

    // MARK: - Public
    func reload() {

        if isHighlighted || isSelected {

            self.bringSubviewToFront(self.highlightView)
            self.highlightView.isHidden = false
        } else {

            self.highlightView.isHidden = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.highlightView.layer.cornerRadius = self.layer.cornerRadius
    }

    // MARK: - Private
    fileprivate lazy var highlightView: UIView = {

        let view = UIView()
        self.addSubview(view)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = self.layer.cornerRadius
        view.backgroundColor = Design.Color.black.withAlphaComponent(0.2)
        view.isHidden = true

        self.addSubview(view)

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
                                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["view": view]))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["view": view]))

        return view
    }()

    fileprivate func replace(startColor: UIColor, endColor: UIColor) {

        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.setNeedsDisplay()
    }

    fileprivate func configure() {

        self.gradientLayer.startPoint = self.direction.startPoint
        self.gradientLayer.endPoint = self.direction.endPoint
        self.gradientLayer.locations = [0.0, 0.80]
        self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
    }
}

enum GradientDirection {

    static var horizontal: GradientDirection { return .horizontally(centered: 0.5) }
    static var vertical: GradientDirection { return .vertically(centered: 0.5) }

    // Value - relative offset gradient center. From 0.0 to 1.0
    case horizontally(centered: CGFloat)
    case vertically(centered: CGFloat)

    // Value - absolute position of gradient colors
    case custom(startPoint: CGPoint, endPoint: CGPoint)

    var startPoint: CGPoint {

        switch self {
            case .horizontally(let xCenter):
                let normalizedCenter = min(1.0, max(0.0, xCenter))
                return CGPoint(x: (normalizedCenter - 0.5), y: 0.0)
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
