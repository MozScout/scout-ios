//
//  VoiceInputViewController.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import Speech
import UIKit

protocol VoiceInputDelegate: class {
    func openVoiceInputFromMain()
    func hideVoiceInputFromMain()
    func addVoiceInputTextFromMain(_ text: String, fromUser: Bool)
    func setVoiceInputImageFromMain(_ image: UIImage)
}

class VoiceInputViewController: UIViewController {
    private var userDefaults: UserDefaults = UserDefaults()

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var listenForWakeWordSwitch: UISwitch!
    @IBOutlet weak var animation: UIImageView!
    @IBOutlet weak var textView: UITextView!

    var speechService: SpeechService!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }

    fileprivate func configureUI() {
        self.listenForWakeWordSwitch.isOn = self.userDefaults.bool(forKey: "listenForWakeWord")
        self.textView.attributedText = NSMutableAttributedString.init(string: "")
        self.addText("How can I help?", fromUser: false)
        self.setImage(UIImage.init(named: "listening")!)
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        self.speechService.endWakeWordDetector()
        self.speechService.stopRecording()

        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }

    @IBAction func listenForWakeWordValueChanged(_ sender: Any) {
        self.userDefaults.set(self.listenForWakeWordSwitch.isOn, forKey: "listenForWakeWord")
    }

    func addText(_ text: String, fromUser: Bool) {
        let content = NSMutableAttributedString.init(attributedString: self.textView.attributedText)
        let string = NSMutableAttributedString.init(string: text + "\n\n")
        let range = NSRange(location: 0, length: text.count + 2)

        if fromUser {
            let style = NSMutableParagraphStyle()
            style.alignment = .right
            string.addAttributes([.paragraphStyle: style, .font: UIFont.systemFont(ofSize: 24)], range: range)

        } else {
            string.addAttributes([.font: UIFont.boldSystemFont(ofSize: 24)], range: range)
        }

        content.append(string)
        self.textView.attributedText = content
    }

    func setImage(_ image: UIImage) {
        self.animation.image = image
    }
}
