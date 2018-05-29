//
//  MainTabBarViewController.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/9/18.
//

import Foundation
import UIKit

protocol MainTabBarViewControllerDelegate: class {
    // maybe need send also several button states
    func mainTabBarViewController(viewController: MainTabBarViewController, didTouchMicrophoneButton button: UIButton)
}

class MainTabBarViewController: UITabBarController {
    
    weak var microphoneButtonDelegate: MainTabBarViewControllerDelegate?
    
    fileprivate var microphoneButton: GradientButton!
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    fileprivate let defaultMicrophoneButtonSideDistance: CGFloat = 16
    fileprivate let defaultMicrophoneButtonAlpha: CGFloat = 0.95

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.bringmicrophoneButtonToFront()
        self.configureTabBarHeight()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = Design.Color.darkWhite
        
        self.setupMicButton()
    }
    
    @objc fileprivate func microphoneButtonAction(sender: UIButton) {
        
        guard let requiredDelegate = microphoneButtonDelegate else { return }
        requiredDelegate.mainTabBarViewController(viewController: self, didTouchMicrophoneButton: sender)
    }
    
    // MARK: - Private methods
    fileprivate func setupMicButton() {
        
        // we need dynamic size of the mic button. should set after we will have design
        microphoneButton = GradientButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        microphoneButton.direction = .custom(startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1.0, y: 1.0))
        microphoneButton.alphaComponent = defaultMicrophoneButtonAlpha
        
        var microphoneButtonFrame = microphoneButton.frame
        microphoneButtonFrame.origin.y = view.bounds.height - microphoneButtonFrame.height - defaultMicrophoneButtonSideDistance
        microphoneButtonFrame.origin.x = view.bounds.width - microphoneButtonFrame.size.width - defaultMicrophoneButtonSideDistance
        microphoneButton.frame = microphoneButtonFrame
        microphoneButton.setImage(UIImage(named: "icn_microphone"), for: .normal)
        
        microphoneButton.layer.cornerRadius = microphoneButtonFrame.height/2
        
        view.addSubview(microphoneButton)
        
        microphoneButton.addTarget(self, action: #selector(microphoneButtonAction(sender:)), for: .touchUpInside)
    }
    
    fileprivate func bringmicrophoneButtonToFront() {
        
        self.view.bringSubview(toFront: self.microphoneButton)
    }
    
    fileprivate func configureTabBarHeight() {
        
        let newTabBarHeight = defaultTabBarHeight + defaultMicrophoneButtonSideDistance
        
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        
        tabBar.frame = newFrame
    }
}
