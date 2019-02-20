//
//  AppDelegate.swift
//  Scout
//
//

import AVFoundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let rootNavigation: RootNavigationViewController = RootNavigationViewController()
    private lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(rootNavigation: rootNavigation)
    }()
    private var window: UIWindow?

//    override init() {
//        let configuration = AppConfiguration()
//
//        // Set up audio session here, since it's used by both the player and the speech service.
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: .defaultToSpeaker)
//            try audioSession.setActive(true, options: [.notifyOthersOnDeactivation])
//        } catch {}
//
//        super.init()
//        self.setDefaultPreferences()
//    }
//
//    private func setDefaultPreferences() {
//        UserDefaults().register(defaults: [
//            "articlePlaybackSpeed": 1.0,
//            "podcastPlaybackSpeed": 1.0,
//            "showRecommendedArticles": true,
//            "sendUsageData": true,
//            "listenForWakeWord": true
//        ])
//    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootNavigation
        window?.makeKeyAndVisible()

        return true
    }
}
