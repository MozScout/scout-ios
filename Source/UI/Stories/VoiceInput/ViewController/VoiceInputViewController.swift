//
//  VoiceInputViewController.swift
//  Scout
//
//  Created by Shurupov Alex on 5/20/18.
//

import UIKit
import Speech

protocol VoiceInputDelegate: class {
    func openPlayer(withLink: String)
}

class VoiceInputViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    weak var playerDelegate: VoiceInputDelegate?
    
    fileprivate let defaultMicrophoneButtonSideDistance: CGFloat = 16
    fileprivate let defaultMicrophoneButtonAlpha: CGFloat = 0.95
    fileprivate var microphoneButton: GradientButton!
    fileprivate var detectionTimer: Timer?
    fileprivate var spinner:UIActivityIndicatorView?
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var scoutClient : ScoutHTTPClient? = nil
    
    @IBOutlet weak var console: UITextView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMicButton()
        speechRecognizer.delegate = self
        spinner = self.addSpinner()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startRecording()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func getURL(withSearchTerm: String) {
        showHUD()
        self.cancelRecording()
        scoutClient?.getAudioFileURL(withCmd: "SearchAndPlayArticle", userid: "scout-mobile@mozilla.com", searchTerms: withSearchTerm, successBlock: { (link) in
            if link == "" {
                self.hideHUD()
                self.showAlert(errorMessage: "please try again")
            }
            else {
                DispatchQueue.main.async {
                    guard let requiredDelegate = self.playerDelegate else { return }
                    requiredDelegate.openPlayer(withLink: link)
                }
            }
        }, failureBlock: { (failureResponse, error, response) in
            
        })
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
        microphoneButton.setImage(UIImage(named: "icn_closeMicrophone"), for: .normal)
        
        microphoneButton.layer.cornerRadius = microphoneButtonFrame.height/2
        
        view.addSubview(microphoneButton)
        
        microphoneButton.addTarget(self, action: #selector(closeMicrophoneButtonAction(sender:)), for: .touchUpInside)
    }
    
    @objc fileprivate func closeMicrophoneButtonAction(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.console.text = result?.bestTranscription.formattedString  //9
                isFinal = (result?.isFinal)!
                
                if let timer = self.detectionTimer, timer.isValid {
                    if isFinal {
                        self.console.text = ""
                        self.detectionTimer?.invalidate()
                    }
                } else {
                    self.detectionTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                        if self.recognitionTask != nil {
                            self.getURL(withSearchTerm: self.console.text)
                        }
                        isFinal = true
                        timer.invalidate()
                    })
                }
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        console.text = "Say something, I'm listening!"
        
    }
    
    func cancelRecording() {
        DispatchQueue.main.async {
            self.recognitionTask?.cancel()
            self.audioEngine.stop()
            let node = self.audioEngine.inputNode
            node.removeTap(onBus: 0)
        }
    }
    
    private func showAlert(errorMessage: String) -> Void {
        let alert = UIAlertController(title: "No records found", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.startRecording()
                
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
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        
        let xConstraint = NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        
        self.view.bringSubview(toFront: spinner)
        
        return spinner
    }
    
    func showHUD() {
        DispatchQueue.main.async {
            self.spinner?.startAnimating()
        }
    }
    
    func hideHUD() {
        DispatchQueue.main.async {
            self.spinner?.stopAnimating()
        }
    }
}
