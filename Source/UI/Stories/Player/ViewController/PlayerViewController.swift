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
    fileprivate var audioPlayer:AVAudioPlayer!
    fileprivate let defaultMicrophoneButtonSideDistance: CGFloat = 6
    fileprivate let defaultMicrophoneButtonAlpha: CGFloat = 0.8
    fileprivate var audioRate: Float = 1.0
    fileprivate var microphoneButton: GradientButton!
    fileprivate var spinner:UIActivityIndicatorView?
    fileprivate var timer : Timer!
    fileprivate let loadingTextLabel = UILabel()
  
    
    @IBOutlet weak var faviconImage: UIImageView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var fullLenghtButton: UIButton!
    @IBOutlet weak var skimButton: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var audioRateButton: UIButton!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var gradientButton: GradientButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //self.setupMicButton()
        configureView()
        spinner = self.addSpinner()
    }

    // MARK: - Private methods
    /*fileprivate func setupMicButton() {
        
        // we need dynamic size of the mic button. should set after we will have design
        microphoneButton = GradientButton(frame: CGRect(x: 0, y: 0, width: 96, height: 96))
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
    }*/
    
    fileprivate func configureView() {
        
        slider.minimumTrackTintColor = UIColor(rgb: 0x6BB4FF)
        slider.maximumTrackTintColor = UIColor(rgb: 0xD7D7DB)
        slider.setThumbImage(UIImage(named: "knob"), for: .normal)
        gradientButton.direction = .horizontally(centered: 0.1)
        if let url = model.articleImageURL {
            self.mainImage.downloadImageFrom(link: (url.absoluteString) , contentMode: .scaleAspectFill)
        }
        self.author.text = model.author
        if let url = model.icon_url {
            self.faviconImage.downloadImageFrom(link: (url.absoluteString) , contentMode: .scaleToFill)
        }
        self.titleLabel.text = model.title
      
        if isFullArticle {
            fullLenghtButton.isSelected = true
            skimButton.isSelected = false
        }
        else {
            fullLenghtButton.isSelected = false
            skimButton.isSelected = true
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

                DispatchQueue.main.async {
                    self.slider.value = 0.0
                    self.slider.maximumValue = Float(self.audioPlayer.duration)
                    self.timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
                }
                self.play()
            }
            catch let error {
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
        if time < 0.0
        {
            audioPlayer.stop()
            audioPlayer.currentTime = 0.0
            self.pauseButton.isSelected = true
        }else
        {
            audioPlayer.currentTime = time
        }
    }
    @IBAction func changeAudioTime(_ sender: Any) {
        slider.maximumValue = Float(audioPlayer.duration)
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(slider.value)
        
        if self.pauseButton.isSelected == false {
            audioPlayer.play()
        }
    }
    
    internal func updatePausePlayButton() {
        if self.pauseButton.isSelected {
            audioPlayer.pause()
        }
        else {
            audioPlayer.play()
        }
    }
    
    internal func play() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print(error)
        }
        audioPlayer.enableRate = true
        audioPlayer.play()
    }
    
    internal func pause() {
        audioPlayer.pause()
    }
    @objc internal func updateSlider(){
        slider.value = Float(audioPlayer.currentTime)
        
        let currentTime = Int(audioPlayer.currentTime)
        let duration = Int(audioPlayer.duration)
        let total = duration - currentTime
        
        let minutes = currentTime/60
        var seconds = currentTime - minutes / 60
        
        let minutesLeft = total/60
        var secondsLeft = total - minutesLeft / 60

        if minutes > 0 {
            seconds = seconds - 60 * minutes
        }
        
        if minutesLeft > 0 {
            secondsLeft = secondsLeft - 60 * minutesLeft
        }
        
        startTime.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        endTime.text = NSString(format: "%02d:%02d", minutesLeft,secondsLeft) as String
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.audioPlayer.stop()
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
    }
    
    @IBAction func skimButtonTapped(_ sender: Any) {
        audioPlayer.stop()
        fullLenghtButton.isSelected = false
        skimButton.isSelected = true
        
        self.showHUD()
        self.scoutClient.getSummaryLink(userid: keychainService.value(for: "userID")!, url: (model.resolvedURL?.absoluteString)!, successBlock: { (scoutArticle) in
            if scoutArticle.url != "" {
                self.downloadfile(url: scoutArticle.url)
                DispatchQueue.main.async {
                    self.pauseButton.isSelected = false
                }
            }
            else {
                DispatchQueue.main.async {
                    self.showAlert(errorMessage: "Skim version is not available")
                    self.playFullArticle(self)
                }
            }
        }, failureBlock: { (failureResponse, error, response) in
            self.showAlert(errorMessage: "Unable to get your articles at this time, please check back later")
            self.hideHUD()
        })
    }
    
    @IBAction func playFullArticle(_ sender: Any) {
        audioPlayer.stop()
        fullLenghtButton.isSelected = true
        skimButton.isSelected = false
        
        self.showHUD()
        self.scoutClient.getArticleLink(userid: keychainService.value(for: "userID")!, url: (model.resolvedURL?.absoluteString)!, successBlock: { (scoutArticle) in
                self.downloadfile(url: scoutArticle.url)
                DispatchQueue.main.async {
                    self.pauseButton.isSelected = false
                }
        }, failureBlock: { (failureResponse, error, response) in
            self.showAlert(errorMessage: "Unable to get your articles at this time, please check back later")
            self.hideHUD()
        })
    }
    
    @IBAction func audioRateButtonTapped(_ sender: Any) {
        audioRate = audioRate + 0.25
        if audioRate > 3.0 {
            audioRate = 1.0
        }
        self.audioRateButton.setTitle(String(format: "%.2fX", audioRate), for: .normal)
        audioPlayer.rate = audioRate
    }
    
    @objc fileprivate func microphoneButtonTapped(sender: UIButton) {
        DispatchQueue.main.async {
            self.pause()
            self.pauseButton.isSelected = true
            guard let requiredDelegate = self.microphoneButtonDelegate else { return }
            requiredDelegate.microphoneButtonTapped()
        }
    }
    
    @IBAction func readArticleButtonTapped(_ sender: Any) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(model.resolvedURL!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(model.resolvedURL!)
        }
    }
    func addSpinner() -> UIActivityIndicatorView {
        // Adding spinner over launch screen
        let spinner = UIActivityIndicatorView.init()
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        
        loadingTextLabel.textColor = UIColor.black
        loadingTextLabel.text = "Preparing your article..."
        loadingTextLabel.font = UIFont(name: "Avenir Light", size: 14)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.textAlignment = .center
        
        self.view.addSubview(loadingTextLabel)
        loadingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingTextLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loadingTextLabel.widthAnchor.constraint(equalToConstant: 175).isActive = true
        loadingTextLabel.centerXAnchor.constraint(equalTo: loadingTextLabel.superview!.centerXAnchor).isActive = true
        loadingTextLabel.centerYAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
        
        let xConstraint = NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: loadingTextLabel, attribute: .leading , multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: loadingTextLabel, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        
        self.loadingTextLabel.isHidden = true
        
        return spinner
    }
    
    func showHUD() {
        DispatchQueue.main.async {
            self.spinner?.startAnimating()
            //self.microphoneButton.isEnabled = false
            self.backButton.isEnabled = false
            self.pauseButton.isEnabled = false
            self.forwardButton.isEnabled = false
            self.backwardButton.isEnabled = false
            self.loadingTextLabel.isHidden = false
            self.fullLenghtButton.isEnabled = false
            self.skimButton.isEnabled = false
            self.slider.isHidden = true
            self.startTime.isHidden = true
            self.endTime.isHidden = true
        }
    }
    
    func hideHUD() {
        DispatchQueue.main.async {
            //self.microphoneButton.isEnabled = true
            self.backButton.isEnabled = true
            self.spinner?.stopAnimating()
            self.pauseButton.isEnabled = true
            self.forwardButton.isEnabled = true
            self.backwardButton.isEnabled = true
            self.fullLenghtButton.isEnabled = true
            self.skimButton.isEnabled = true
            self.loadingTextLabel.isHidden = true
            self.slider.isHidden = false
            self.startTime.isHidden = false
            self.endTime.isHidden = false
        }
    }
    
    private func showAlert(errorMessage: String) -> Void {
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("ok")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}
