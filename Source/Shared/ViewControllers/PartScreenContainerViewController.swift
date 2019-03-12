//
//  PartScreenContainerViewController.swift
//  Scout
//
//

import UIKit

class PartScreenContainerViewController: UIViewController {

    typealias Content = UIViewController

    // MARK: - Private properties

    private let blurBackgroundView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let shadowContainerView: UIView = UIView()
    private let contentContainerView: UIView = UIView()
    private let dismissGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()

    private var currentContent: Content?

    private let cornerRadius: CGFloat = 6

    // MARK: - Public properties

    public var onDismiss: (() -> Void)?

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Public methods

    public func setContent(_ newContent: Content) {
        if let content = currentContent {
            remove(childController: content)
        }

        addChildViewController(newContent, to: contentContainerView)
        currentContent = newContent
    }

    // MARK: - Private methods

    private func setup() {
        setupView()
        setupBlurBackgroundView()
        setupShadowContainerView()
        setupContentContainerView()
        setupDismissGestureRecognizer()

        setupLayout()
    }

    private func setupView() {
        view.backgroundColor = UIColor.clear
    }

    private func setupBlurBackgroundView() {
        blurBackgroundView.addGestureRecognizer(dismissGestureRecognizer)
    }

    private func setupShadowContainerView() {
        shadowContainerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        shadowContainerView.layer.shadowRadius = 4
        shadowContainerView.layer.shadowOpacity = 0.3
        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
    }

    private func setupContentContainerView() {
        contentContainerView.backgroundColor = UIColor.white
        contentContainerView.layer.cornerRadius = cornerRadius
        contentContainerView.layer.masksToBounds = true
        contentContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func setupDismissGestureRecognizer() {
        dismissGestureRecognizer.addTarget(self, action: #selector(dismissGestureRecognizerAction))
        dismissGestureRecognizer.cancelsTouchesInView = false
    }

    @objc private func dismissGestureRecognizerAction() {
        onDismiss?()
    }

    private func setupLayout() {
        view.addSubview(blurBackgroundView)
        view.addSubview(shadowContainerView)
        shadowContainerView.addSubview(contentContainerView)

        blurBackgroundView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(cornerRadius)
        }

        shadowContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(blurBackgroundView.snp.bottom).offset(-cornerRadius)
            make.left.right.bottom.equalToSuperview()
        }

        contentContainerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
