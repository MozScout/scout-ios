//
//  PlayerViewController.swift
//  Scout
//
//  Created by Shurupov Alex on 5/23/18.
//

import UIKit
import AVFoundation

protocol PlayerViewControllerDelegate: class {
    // maybe need send also several button states
    func backButtonTapped()
    func microphoneButtonTapped()
}

class PlayerViewController: UIViewController {
    
    weak var backButtonDelegate: PlayerViewControllerDelegate?
    weak var microphoneButtonDelegate: PlayerViewControllerDelegate?
    var scoutClient : ScoutHTTPClient!
    var model: ScoutArticle!
    var keychainService : KeychainService!
    var isFullArticle : Bool = true
    fileprivate var player = AVPlayer()
    fileprivate var audioPlayer:AVAudioPlayer!
    fileprivate let defaultMicrophoneButtonSideDistance: CGFloat = 16
    fileprivate let defaultMicrophoneButtonAlpha: CGFloat = 0.95
    fileprivate var microphoneButton: GradientButton!
    fileprivate var spinner:UIActivityIndicatorView?
    fileprivate let yourAttributes : [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 10),
        NSAttributedStringKey.foregroundColor : UIColor.black,
        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
    
    fileprivate var attributedString = NSMutableAttributedString(string:"")
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var fullLenghtButton: UIButton!
    @IBOutlet weak var skimButton: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupMicButton()
        configureView()
        spinner = self.addSpinner()
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
        
        microphoneButton.addTarget(self, action: #selector(microphoneButtonTapped(sender:)), for: .touchUpInside)
    }
    
    fileprivate func configureView() {
        if let url = model.articleImageURL {
            if let data = try? Data(contentsOf: url)
            {
                self.mainImage.image = UIImage(data: data)!
            }
        }
        self.titleLabel.text = model.title
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        if isFullArticle {
            attributedString = NSMutableAttributedString(string: "Full Length",
                                                         attributes: yourAttributes)
        
            fullLenghtButton.setAttributedTitle(attributedString, for: .normal)
        }
        else {
            attributedString = NSMutableAttributedString(string: "Skim",
                                                         attributes: yourAttributes)
            
            skimButton.setAttributedTitle(attributedString, for: .normal)
        }
        self.downloadfile(url: model.url)
    }
    
    func downloadfile(url: String) {
        self.showHUD()
        
        if let audioUrl = URL(string: url) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                self.playDownloadedFile(url: audioUrl.absoluteString)
                self.hideHUD()
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                        self.playDownloadedFile(url: audioUrl.absoluteString)
                        self.hideHUD()
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
            }
        }
    }
    
    func playDownloadedFile(url: String) {
        
        if let audioUrl = URL(string: url) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                guard let player = audioPlayer else { return }
                
                player.prepareToPlay()
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    @IBAction func pauseButtonTaped(_ sender: Any) {
        self.pauseButton.isSelected = !pauseButton.isSelected
        updatePausePlayButton()
    }
    
    @IBAction func forwardButtonAction(_ sender: Any) {
        var time: TimeInterval = audioPlayer.currentTime
        time += 30.0 // Go forward by 30 seconds
        if time > audioPlayer.duration
        {
            audioPlayer.stop()
            audioPlayer.currentTime = 0.0
            self.pauseButton.isSelected = true
        }else
        {
            audioPlayer.currentTime = time
        }
    }
    
    @IBAction func backwardButtonAction(_ sender: Any) {
        var time: TimeInterval = audioPlayer.currentTime
        time -= 30.0 // Go backward by 30 seconds
        if time < audioPlayer.duration
        {
            audioPlayer.stop()
            audioPlayer.currentTime = 0.0
            self.pauseButton.isSelected = true
        }else
        {
            audioPlayer.currentTime = time
        }
    }
    
    internal func updatePausePlayButton() {
        if self.pauseButton.isSelected {
            pause()
        }
        else {
            play()
        }
    }
    
    internal func play() {
        audioPlayer.play()
    }
    
    internal func pause() {
        audioPlayer.pause()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        guard let requiredDelegate = backButtonDelegate else { return }
        requiredDelegate.backButtonTapped()
    }
    
    @IBAction func skimButtonTapped(_ sender: Any) {
        audioPlayer.stop()
        attributedString = NSMutableAttributedString(string: "Skim",
                                                    attributes: yourAttributes)
        skimButton.setAttributedTitle(attributedString, for: .normal)
        fullLenghtButton.setAttributedTitle(nil, for: .normal)
        
        self.showHUD()
        self.scoutClient.getSummaryLink(userid: keychainService.value(for: "userID")!, url: (model.resolvedURL?.absoluteString)!, successBlock: { (scoutArticle) in
                self.downloadfile(url: scoutArticle.url)
        }, failureBlock: { (failureResponse, error, response) in
        })
    }
    
    @IBAction func readArticleButtonTapped(_ sender: Any) {
        UIApplication.shared.open(model.resolvedURL!, options: [:], completionHandler: nil)
    }
    
    @IBAction func playFullArticle(_ sender: Any) {
        
        audioPlayer.stop()
        attributedString = NSMutableAttributedString(string: "Full Length",
                                                    attributes: yourAttributes)
        
        fullLenghtButton.setAttributedTitle(attributedString, for: .normal)
        attributedString = NSMutableAttributedString(string: "Skim",
                                                     attributes: nil)
        self.skimButton.setAttributedTitle(attributedString, for: .normal)
        
        self.showHUD()
        self.scoutClient.getArticleLink(userid: keychainService.value(for: "userID")!, url: (model.resolvedURL?.absoluteString)!, successBlock: { (scoutArticle) in
            self.downloadfile(url: scoutArticle.url)
        }, failureBlock: { (failureResponse, error, response) in
        })
    }
    
    @objc fileprivate func microphoneButtonTapped(sender: UIButton) {
        DispatchQueue.main.async {
            self.pause()
            self.pauseButton.isSelected = true
            guard let requiredDelegate = self.microphoneButtonDelegate else { return }
            requiredDelegate.microphoneButtonTapped()
        }
    }
    
    func addSpinner() -> UIActivityIndicatorView {
        // Adding spinner over launch screen
        let spinner = UIActivityIndicatorView.init()
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        spinner.color = UIColor.white
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
            self.microphoneButton.isEnabled = false
            self.pauseButton.isEnabled = false
            self.forwardButton.isEnabled = false
            self.backwardButton.isEnabled = false
        }
    }
    
    func hideHUD() {
        DispatchQueue.main.async {
            self.microphoneButton.isEnabled = true
            self.spinner?.stopAnimating()
            self.pauseButton.isEnabled = true
            self.forwardButton.isEnabled = true
            self.backwardButton.isEnabled = true
        }
    }
}

class Downloader {
    class func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = try! URLRequest(url: url, method: .get)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completion()
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }
                
            } else {
                print("Failure: %@", error?.localizedDescription ?? "");
            }
        }
        task.resume()
    }
}
