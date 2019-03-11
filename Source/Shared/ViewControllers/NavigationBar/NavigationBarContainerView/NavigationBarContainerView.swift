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
    @IBOutlet private weak var gradientSeparatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentContainerView: UIView!
    @IBOutlet private weak var contentContainerViewBottomConstraint: NSLayoutConstraint!

    private var currentContent: UIView?

    public let gradientSeparatorHeight: CGFloat = 3
    public let contentHeight: CGFloat = 44

    // MARK: - Public properties

    public var collapsedHeight: CGFloat {
        return gradientSeparatorHeight + safeAreaInsets.top
    }

    public var expandedHeight: CGFloat {
        return collapsedHeight + contentHeight
    }

    public var currentHeight: CGFloat {
        return collapsedHeight + currentConstant
    }

    public var currentConstant: CGFloat {
        return contentContainerViewBottomConstraint.constant
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

    public func set(_ constant: CGFloat) {
        let percent = constant / (expandedHeight - collapsedHeight)
        contentContainerView.alpha = percent

        contentContainerViewBottomConstraint.constant = constant
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
        gradientSeparatorHeightConstraint.constant = gradientSeparatorHeight
        gradientSeparator.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientSeparator.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientSeparator.gradientLayer.colors = [
            UIColor.fxRadicalRed.cgColor,
            UIColor.fxYellowOrange.cgColor
        ]
    }
}
