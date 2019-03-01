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

    private let navigationBarContent = DefaultNavigationBar.loadFromNib()
    private let editButton: UIButton = {
        let editButton: UIButton = UIButton(type: .system)
        editButton.setTitle("Edit", for: .normal)
        editButton.titleLabel?.font = UIFont.openSans(ofSize: 14)
        editButton.setTitleColor(UIColor.fxScienceBlue, for: .normal)
        return editButton
    }()

    private let cancelButton: UIButton = {
        let cancelButton: UIButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.openSans(ofSize: 14)
        cancelButton.setTitleColor(UIColor.fxScienceBlue, for: .normal)
        return cancelButton
    }()

    var onScrollViewDidScroll: OnScrollViewDidScroll?

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollViewContent.backgroundColor = UIColor.red
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.keyboardDismissMode = .onDrag

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

        cancelButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)

//        let back = BackNavigationBar.loadFromNib()
//        back.title = "Top 100 Podcasts"
//        navigationBarContainer?.setNavigationBarContent(back)

//        let search = SearchNavigationBar.loadFromNib()
//        navigationBarContainer?.setNavigationBarContent(search)

        navigationBarContainer?.setNavigationBarContent(navigationBarContent)
        navigationBarContent.setRightItem(cancelButton)
    }

    @objc private func editButtonAction() {
        if editButton.superview == nil {
            navigationBarContent.setRightItem(editButton)
            navigationBarContainer?.hidesNavigationBarOnScroll = true
        } else {
            navigationBarContent.setRightItem(cancelButton)
            navigationBarContainer?.hidesNavigationBarOnScroll = false
        }
    }

    @objc private func buttonAction() {
        navigationBarContainer?.hidesNavigationBarOnScroll = !(navigationBarContainer?.hidesNavigationBarOnScroll ?? false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateInsets()
    }

    private func updateInsets() {
        let topInset = topOverlayHeight(view: scrollView)
        let bottomInset = bottomOverlayHeight(view: scrollView)

        let shouldScrollToTop = scrollView.contentOffset.y == -scrollView.contentInset.top

        let inset = UIEdgeInsets(
            top: topInset,
            left: scrollView.contentInset.left,
            bottom: bottomInset,
            right: scrollView.contentInset.right
        )

        scrollView.contentInset = inset
        scrollView.scrollIndicatorInsets = inset

        if shouldScrollToTop {
            let contentOffset = CGPoint(x: scrollView.contentOffset.x, y: -inset.top)
            scrollView.setContentOffset(contentOffset, animated: false)
        }
    }
}

extension TestViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollViewDidScroll?(scrollView)
    }
}
