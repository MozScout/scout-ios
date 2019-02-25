//
//  GradientView.swift
//  Scout
//
//

import UIKit

class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self

    }

    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
}
