//
//  Switcher.swift
//  Scout
//
//

import UIKit

class Switcher: UIView {

    // MARK: - Private properties

    private let backgroundOval: UIView = UIView()
    private let onBackground: UIView = UIView()
    private let offBackground: UIView = UIView()
    private let thumbShadowContainer: UIView = UIView()
    private let thumb: UIView = UIView()

    private let thumbSize: CGFloat = 12
    private let backgroundOvalSize: CGSize = CGSize(width: 32, height: 6)
    private let sizeMultiplier: CGFloat = 1

    private var relevantThumbSize: CGFloat {
        return thumbSize * sizeMultiplier
    }

    private var relevantBackgroundOvalSize: CGSize {
        return CGSize(
            width: backgroundOvalSize.width * sizeMultiplier,
            height: backgroundOvalSize.height * sizeMultiplier
        )
    }

    // MARK: - Public properties

    public var isOn: Bool = false {
        didSet {
            updateIsOn(animated: true)
        }
    }

    public var isEnabled: Bool = true {
        didSet {
            updateAppearance()
        }
    }

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

    public func setOn(_ isOn: Bool, animated: Bool) {
        updateIsOn(animated: animated)
    }

    // MARK: - Private methods

    private func commonInit() {
        setupView()
        setupBackgroundOval()
        setupOnBackground()
        setupOffBackground()
        setupThumbShadowContainer()
        setupThumb()

        setupLayout()

        updateAppearance()
    }

    private func setupView() {
        backgroundColor = UIColor.clear
    }

    private func setupBackgroundOval() {
        backgroundOval.layer.cornerRadius = 2
        backgroundOval.layer.masksToBounds = true
    }

    private func setupOnBackground() {
        onBackground.backgroundColor = UIColor.fxScienceBlue
    }

    private func setupOffBackground() {
        offBackground.backgroundColor = UIColor.fxBombay
    }

    private func setupThumbShadowContainer() {
        thumbShadowContainer.backgroundColor = UIColor.clear
        thumbShadowContainer.layer.shadowColor = UIColor.fxBlack.cgColor
        thumbShadowContainer.layer.shadowRadius = 3.0 / 2.0
        thumbShadowContainer.layer.shadowOpacity = 0.5
        thumbShadowContainer.layer.shadowOffset = .zero
    }

    private func setupThumb() {
        thumb.backgroundColor = UIColor.white
        thumb.layer.cornerRadius = relevantThumbSize / 2.0
        thumb.layer.masksToBounds = true
    }

    private func setupLayout() {
        addSubview(backgroundOval)
        backgroundOval.addSubview(offBackground)
        backgroundOval.addSubview(onBackground)
        addSubview(thumbShadowContainer)
        thumbShadowContainer.addSubview(thumb)

        backgroundOval.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(relevantThumbSize / 4.0)
            make.height.equalTo(self.relevantBackgroundOvalSize.height)
            make.width.equalTo(self.relevantBackgroundOvalSize.width)
            make.centerY.equalToSuperview()
        }

        offBackground.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
        }

        onBackground.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(self.offBackground.snp.left)
            make.right.equalTo(thumbShadowContainer.snp.centerX)
        }

        thumb.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        updateIsOn(animated: false)
    }

    private func updateAppearance() {
        if isEnabled {
            onBackground.backgroundColor = UIColor.fxScienceBlue
            offBackground.backgroundColor = UIColor.fxBombay
        } else {
            onBackground.backgroundColor = UIColor.fxMishka
            offBackground.backgroundColor = UIColor.fxMishka
        }
    }

    private func updateIsOn(animated: Bool) {
        UIView.animate(
            withDuration: animated ? 0.15 : 0
        ) {

            self.thumbShadowContainer.snp.remakeConstraints { (make) in
                make.size.equalTo(self.relevantThumbSize)
                make.top.bottom.equalToSuperview()
                make.centerY.equalToSuperview()
                if self.isOn && self.isEnabled {
                    make.right.equalToSuperview()
                } else {
                    make.left.equalToSuperview()
                }
            }

            self.updateAppearance()
//            self.thumbShadowContainer.superview?.layoutIfNeeded()
        }
    }
}
