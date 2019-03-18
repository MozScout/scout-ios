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
    }

    private func setupThumb() {
        thumb.backgroundColor = UIColor.white
        thumb.layer.cornerRadius = 7.5
        thumb.layer.masksToBounds = true
    }

    private func setupLayout() {
        addSubview(backgroundOval)
        backgroundOval.addSubview(offBackground)
        backgroundOval.addSubview(onBackground)
        addSubview(thumbShadowContainer)
        thumbShadowContainer.addSubview(thumb)

        backgroundOval.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(7.5)
            make.width.equalTo(32)
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
            withDuration: animated ? TimeInterval(UINavigationController.hideShowBarDuration) : 0
        ) {

            self.thumbShadowContainer.snp.remakeConstraints { (make) in
                make.size.equalTo(15)
                make.centerY.equalToSuperview()
                if self.isOn {
                    make.right.equalToSuperview()
                } else {
                    make.left.equalToSuperview()
                }
            }

            self.updateAppearance()
        }
    }
}
