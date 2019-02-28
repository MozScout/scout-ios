//
//  TestViewController.swift
//  Scout
//
//

import UIKit

class TestViewController: UIViewController, NavigationBarContainerContent {

    private let scrollView: UIScrollView = UIScrollView()
    private let scrollViewContent: UIView = UIView()
    private let button: UIButton = UIButton()

    var onScrollViewDidScroll: OnScrollViewDidScroll?

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollViewContent.backgroundColor = UIColor.red
        scrollView.contentInsetAdjustmentBehavior = .never

        button.setTitle("Change hides", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        view.addSubview(scrollView)
        view.addSubview(button)
        scrollView.addSubview(scrollViewContent)

        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        scrollViewContent.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(3000)
        }

        button.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

        let navigationBarContent = DefaultNavigationBar.loadFromNib()
        navigationBarContainer?.setNavigationBarContent(navigationBarContent)
    }

    @objc private func buttonAction() {
        navigationBarContainer?.hidesNavigationBarOnScroll = !(navigationBarContainer?.hidesNavigationBarOnScroll ?? false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let inset = UIEdgeInsets(
            top: topOverlayHeight(view: scrollView),
            left: scrollView.contentInset.left,
            bottom: bottomOverlayHeight(view: scrollView),
            right: scrollView.contentInset.right
        )

        scrollView.contentInset = inset
        scrollView.scrollIndicatorInsets = inset
    }
}

extension TestViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollViewDidScroll?(scrollView)
    }
}
