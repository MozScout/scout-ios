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

class MainTabBarViewController: UITabBarController, SBSpeechRecognizerDelegate {
    weak var microphoneButtonDelegate: MainTabBarViewControllerDelegate?

    fileprivate var microphoneButton: GradientButton!
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()

    fileprivate let defaultMicrophoneButtonSideDistance: CGFloat = 10
    fileprivate let defaultMicrophoneButtonAlpha: CGFloat = 0.8

    var speechService: SpeechService!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //self.bringmicrophoneButtonToFront()
        self.configureTabBarHeight()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = Design.Color.darkWhite
        tabBar.isTranslucent = false

        //self.setupMicButton()
    }

    func beginWakeWordDetector() {
        self.speechService.delegate = self
        self.speechService.beginWakeWordDetector()
    }

    @objc fileprivate func microphoneButtonAction(sender: UIButton) {
        guard let requiredDelegate = microphoneButtonDelegate else { return }
        requiredDelegate.mainTabBarViewController(viewController: self, didTouchMicrophoneButton: sender)
    }

    // MARK: - Private methods
    /*fileprivate func setupMicButton() {
        // we need dynamic size of the mic button. should set after we will have design
        microphoneButton = GradientButton(frame: CGRect(x: 0, y: 0, width: 96, height: 96))
        microphoneButton.direction = .custom(startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1.0, y: 1.0))
        microphoneButton.alphaComponent = defaultMicrophoneButtonAlpha

        var microphoneButtonFrame = microphoneButton.frame
        microphoneButtonFrame.origin.y =
            view.bounds.height - microphoneButtonFrame.height - defaultMicrophoneButtonSideDistance
        microphoneButtonFrame.origin.x =
            view.bounds.width - microphoneButtonFrame.size.width - defaultMicrophoneButtonSideDistance
        microphoneButton.frame = microphoneButtonFrame
        microphoneButton.setImage(UIImage(named: "icn_microphone"), for: .normal)

        microphoneButton.layer.cornerRadius = microphoneButtonFrame.height/2

        view.addSubview(microphoneButton)

        microphoneButton.addTarget(self, action: #selector(microphoneButtonAction(sender:)), for: .touchUpInside)
    }

    fileprivate func bringmicrophoneButtonToFront() {
        self.view.bringSubview(toFront: self.microphoneButton)
    }*/

    fileprivate func configureTabBarHeight() {
        let newTabBarHeight = defaultTabBarHeight + defaultMicrophoneButtonSideDistance

        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight

        tabBar.frame = newFrame
    }

    func speechRecognitionFinished(transcription: String) {
        print("transcription result: \(transcription)")
        self.speechService.beginWakeWordDetector()
        /*
        if self.console.text.range(of: "Skim ") != nil {
            self.console.text.removeSubrange(self.console.text.range(of: "Skim ")!)
            self.getSkimURL(withSearchTerm: self.console.text)
        } else if self.console.text.range(of: "Skim that article about ") != nil {
            self.console.text.removeSubrange(self.console.text.range(of: "Skim that article about ")!)
            self.getSkimURL(withSearchTerm: self.console.text)
        } else if self.console.text.range(of: "Skim that article ") != nil {
            self.console.text.removeSubrange(self.console.text.range(of: "Skim that article ")!)
            self.getSkimURL(withSearchTerm: self.console.text)
        } else if self.console.text.range(of: "Skim article about ") != nil {
            self.console.text.removeSubrange(self.console.text.range(of: "Skim article about ")!)
            self.getSkimURL(withSearchTerm: self.console.text)
        } else if self.console.text.range(of: "Play that article about ") != nil {
            self.console.text.removeSubrange(self.console.text.range(of: "Play that article about ")!)
            self.getURL(withSearchTerm: self.console.text)
        } else if self.console.text.range(of: "Play article about ") != nil {
            self.console.text.removeSubrange(self.console.text.range(of: "Play article about ")!)
            self.getURL(withSearchTerm: self.console.text)
        } else if self.console.text.range(of: "Play that article ") != nil {
            self.console.text.removeSubrange(self.console.text.range(of: "Play that article ")!)
            self.getURL(withSearchTerm: self.console.text)
        } else if self.console.text.range(of: "Play ") != nil {
            self.console.text.removeSubrange(self.console.text.range(of: "Play ")!)
            self.getURL(withSearchTerm: self.console.text)
        } else if self.console.text.range(of: "Scout that article about ") != nil {
            self.console.text.removeSubrange(self.console.text.range(of: "Scout that article about ")!)
            self.getURL(withSearchTerm: self.console.text)
        } else if self.console.text.range(of: "Scout article about ") != nil {
            self.console.text.removeSubrange(self.console.text.range(of: "Scout article about ")!)
            self.getURL(withSearchTerm: self.console.text)
        } else if self.console.text.range(of: "Scout that article ") != nil {
            self.console.text.removeSubrange(self.console.text.range(of: "Scout that article ")!)
            self.getURL(withSearchTerm: self.console.text)
        } else {
            if self.console.text.range(of: "Scout ") != nil {
                self.console.text.removeSubrange(self.console.text.range(of: "Scout ")!)
                self.getURL(withSearchTerm: self.console.text)
            } else {
                self.getURL(withSearchTerm: self.console.text)
            }
        }
        */
    }

    func speechRecognitionPartialResult(transcription: String) {
        print("transcription partial result: \(transcription)")
        /*
        self.console.text = transcription
        self.microphoneButton.isEnabled = false
        */
    }

    func wakeWordDetected() {
        print("Got wake word!")
        self.speechService.startRecording()
    }
}
