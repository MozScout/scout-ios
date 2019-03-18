//
//  PlayerButton.swift
//  Scout
//
//

import UIKit

class PlayerButton: UIView {

    // MARK: - Private properties

    private let contentViewContainer: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()

    private var currentContent: UIView?

    // MARK: - Public properties

    public let normalColor: UIColor = UIColor.fxScienceBlue
    public let disabledColor: UIColor = UIColor.fxMishka

    public var isEnabled: Bool = true {
        didSet {
            updateAppearance()
        }
    }

    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    public var onDidTap: (() -> Void)?

    // MARK: -

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    // MARK: - Public methods

    public func setContent(_ content: UIView?) {
        currentContent?.removeFromSuperview()

        currentContent = content
        if let content = currentContent {
            contentViewContainer.addSubview(content)
            content.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }

    public func updateAppearance() {
        if isEnabled {
            titleLabel.textColor = normalColor
        } else {
            titleLabel.textColor = disabledColor
        }
    }

    // MARK: - Private methods

    private func commonInit() {
        setupTapGestureRecognizer()
        setupView()
        setupContentViewContainer()
        setupTitleLabel()

        setupLayout()

        updateAppearance()
    }

    private func setupTapGestureRecognizer() {
        tapGestureRecognizer.addTarget(self, action: #selector(tapGestureRecognizerAction))
        tapGestureRecognizer.cancelsTouchesInView = true
    }

    @objc private func tapGestureRecognizerAction() {
        guard isEnabled else { return }
        onDidTap?()
    }

    private func setupView() {
        backgroundColor = UIColor.clear
        addGestureRecognizer(tapGestureRecognizer)
    }

    private func setupContentViewContainer() {
        contentViewContainer.backgroundColor = UIColor.clear
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.sfCompactText(.regular, ofSize: 10)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
    }

    private func setupLayout() {
        addSubview(contentViewContainer)
        addSubview(titleLabel)

        contentViewContainer.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(24)
        }

        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.contentViewContainer.snp.bottom).offset(-2)
        }
    }
}
