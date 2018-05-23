//
//  PlayerViewController.swift
//  Scout
//
//  Created by Shurupov Alex on 5/23/18.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    var scoutClient : ScoutHTTPClient? = nil
    var link: String? = nil
    var player = AVPlayer()
    fileprivate let defaultMicrophoneButtonSideDistance: CGFloat = 16
    fileprivate let defaultMicrophoneButtonAlpha: CGFloat = 0.95
    fileprivate var microphoneButton: GradientButton!
    fileprivate let seekDuration: Float64 = 30
    
    @IBOutlet weak var pauseButton: UIButton!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupMicButton()
        configureView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    fileprivate func configureView() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        let urlString = link
        guard let url = URL.init(string: urlString!)
            else {
                return
        }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        player.play()
    }
    
    @objc fileprivate func microphoneButtonAction(sender: UIButton) {
        
    }
    
    @IBAction func pauseButtonTaped(_ sender: Any) {
        self.pauseButton.isSelected = !pauseButton.isSelected
        updatePausePlayButton()
    }
    
    @IBAction func forwardButtonAction(_ sender: Any) {
        guard let duration  = player.currentItem?.duration else{
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = playerCurrentTime + seekDuration
        
        if newTime < CMTimeGetSeconds(duration) {
            
            let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
            player.seek(to: time2)
        }
    }
    
    @IBAction func backwardButtonAction(_ sender: Any) {
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = playerCurrentTime - seekDuration
        
        if newTime < 0 {
            newTime = 0
        }
        let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
        player.seek(to: time2)
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
        player.play()
    }
    
    internal func pause() {
        player.pause()
    }
    
}
