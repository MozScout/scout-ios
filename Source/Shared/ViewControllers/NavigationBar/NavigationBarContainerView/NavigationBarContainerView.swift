//
//  NavigationBarContainerView.swift
//  Scout
//
//

import UIKit

class NavigationBarContainerView: UIView {

    // MARK: - Private properties

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var gradientSeparator: GradientView!
    @IBOutlet private weak var contentContainerView: UIView!

    private var currentContent: UIView?

    // MARK: - Public properties

    public var collapsedHeight: CGFloat {
        return 3
    }

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
        setupContentView()
        setupGradientSeparator()
    }

    // MARK: - Public methods

    public func setContent(_ content: UIView) {
        currentContent?.removeFromSuperview()
        contentContainerView.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        currentContent = content
    }

    // MARK: - Private methods

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

    private func setupView() {
        backgroundColor = UIColor.clear
    }

    private func setupContentView() {
        contentView.backgroundColor = UIColor.clear
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
