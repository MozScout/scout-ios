//
//  NavigationBarView.swift
//  Scout
//
//

import UIKit

class NavigationBarView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var gradientSeparator: GradientView!

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
        setupLogoImageView()
        setupGradientSeparator()
    }

    private func setup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds

        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(contentView)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Cannot get view from nib")
        }

        return view
    }

    // MARK: - Private methods

    private func setupView() {

    }

    private func setupLogoImageView() {
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = #imageLiteral(resourceName: "player_image")
    }

    private func setupGradientSeparator() {
        gradientSeparator.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientSeparator.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientSeparator.gradientLayer.colors = [
            UIColor.fxRadicalRed.cgColor,
            UIColor.fxYellowOrange.cgColor
        ]
    }
}
