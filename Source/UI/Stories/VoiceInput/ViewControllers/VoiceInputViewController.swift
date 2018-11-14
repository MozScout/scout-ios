//
//  VoiceInputViewController.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import Speech
import UIKit

protocol VoiceInputDelegate: class {
    func openPlayer(withModel: ScoutArticle, isFullArticle: Bool)
}

class VoiceInputViewController: UIViewController, SBSpeechRecognizerDelegate {
    weak var playerDelegate: VoiceInputDelegate?

    fileprivate let defaultMicrophoneButtonSideDistance: CGFloat = 11
    fileprivate let defaultMicrophoneButtonAlpha: CGFloat = 0.8
    fileprivate var microphoneButton: GradientButton!
    fileprivate var detectionTimer: Timer?
    fileprivate var spinner: UIActivityIndicatorView?

    var scoutClient: ScoutHTTPClient!
    var speechService: SpeechService!
    var userID: String = ""

    @IBOutlet weak var console: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMicButton()
        self.configureUI()
        speechService.startRecording()
    }

    fileprivate func configureUI() {
        spinner = self.addSpinner()
        speechService.delegate = self
        console.text = "Scout that article about "
    }

    fileprivate func getURL(withSearchTerm: String) {
        showHUD()
        speechService.stopRecording()
        scoutClient.getAudioFileURL(withCmd: "SearchAndPlayArticle",
                                    userid: self.userID,
                                    searchTerms: withSearchTerm,
                                    successBlock: { (scoutArticle) in
                                        if scoutArticle.url == "" {
                                            self.hideHUD()
                                            self.showAlert(errorMessage: "Sorry, I couldn't find that.")
                                        } else {
                                            DispatchQueue.main.async {
                                                guard let requiredDelegate = self.playerDelegate else { return }
                                                requiredDelegate.openPlayer(withModel: scoutArticle,
                                                                            isFullArticle: true)
                                            }
                                        }
                                    }, failureBlock: { (_, _, _) in
                                        self.showAlert(errorMessage: """
                                                       Unable to get your articles at this time, please check back \
                                                       later
                                                       """)
                                        self.hideHUD()
                                    })
    }

    fileprivate func getSkimURL(withSearchTerm: String) {
        showHUD()
        speechService.stopRecording()
        _ = scoutClient.getSkimAudioFileURL(withCmd: "SearchAndSummarizeArticle",
                                            userid: self.userID,
                                            searchTerms: withSearchTerm,
                                            successBlock: { (scoutArticle) in
                                                if scoutArticle.url == "" {
                                                    self.hideHUD()
                                                    self.showAlert(errorMessage: "Sorry, I couldn't find that.")
                                                } else {
                                                    DispatchQueue.main.async {
                                                        guard let requiredDelegate = self.playerDelegate else { return }
                                                        requiredDelegate.openPlayer(withModel: scoutArticle,
                                                                                    isFullArticle: false)
                                                    }
                                                }
                                            }, failureBlock: { (_, _, _) in
                                                self.showAlert(errorMessage: """
                                                               Unable to get your articles at this time, please check \
                                                               back later
                                                               """)
                                                self.hideHUD()
                                            })
    }
    // MARK: - Private methods
    fileprivate func setupMicButton() {
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
        microphoneButton.setImage(UIImage(named: "icn_closeMicrophone"), for: .normal)

        microphoneButton.layer.cornerRadius = microphoneButtonFrame.height / 2

        view.addSubview(microphoneButton)

        microphoneButton.addTarget(self, action: #selector(closeMicrophoneButtonAction(sender:)), for: .touchUpInside)
    }

    @objc fileprivate func closeMicrophoneButtonAction(sender: UIButton) {
        speechService.stopRecording()
        navigationController?.popViewController(animated: true)
    }

    private func showAlert(errorMessage: String) {
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style {
                case .default:
                    self.console.text = "Scout that article about "
                    self.speechService.startRecording()

                case .cancel:
                    print("cancel")

                case .destructive:
                    print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }

    func addSpinner() -> UIActivityIndicatorView {
        // Adding spinner over launch screen
        let spinner = UIActivityIndicatorView.init()
        spinner.style = UIActivityIndicatorView.Style.whiteLarge
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)

        let xConstraint = NSLayoutConstraint(item: spinner,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self.view,
                                             attribute: .centerX,
                                             multiplier: 1,
                                             constant: 0)
        let yConstraint = NSLayoutConstraint(item: spinner,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: self.view,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant: 0)

        NSLayoutConstraint.activate([xConstraint, yConstraint])

        self.view.bringSubviewToFront(spinner)

        return spinner
    }

    func showHUD() {
        DispatchQueue.main.async {
            self.spinner?.startAnimating()
        }
    }

    func hideHUD() {
        DispatchQueue.main.async {
            self.microphoneButton.isEnabled = true
            self.spinner?.stopAnimating()
        }
    }

    func speechRecognitionFinished(transcription: String) {
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
    }

    func speechRecognitionPartialResult(transcription: String) {
        self.console.text = transcription
        self.microphoneButton.isEnabled = false
    }

    func wakeWordDetected() {
    }
}
