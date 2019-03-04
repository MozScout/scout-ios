//
//  ApplicationRouter.swift
//  Scout
//
//

import UIKit

class ApplicationRouter: NSObject {
    let applicationAssembly: ApplicationAssemblyProtocol

    fileprivate var navigationController: UINavigationController!
    fileprivate var podcastsRouter: PodcastsRoutingProtocol
    fileprivate var myListRouter: MyListRoutingProtocol
    fileprivate var authRouter: AuthRoutingProtocol
    fileprivate var voiceInputRouter: VoiceInputRoutingProtocol
    fileprivate var playerRouter: PlayerRoutingProtocol

    required init(with applicationAssembly: ApplicationAssemblyProtocol) {
        self.applicationAssembly = applicationAssembly

        // Routers
        self.myListRouter = applicationAssembly.assemblyMyListRouter()
        self.authRouter = applicationAssembly.assemblyAuthRouter()
        self.voiceInputRouter = applicationAssembly.assemblyVoiceInputRouter()
        self.playerRouter = applicationAssembly.assemblyPlayerRouter()
        self.podcastsRouter = applicationAssembly.assemblyPodcastsRouter()
        super.init()
    }
}

// MARK: -
// MARK: ApplicationRouter
extension ApplicationRouter: ApplicationRouterProtocol {
    func show(from window: UIWindow) {
        self.showLogin(from: window)
    }

    func applicationDidBecomeActive() {
        self.myListRouter.applicationDidBecomeActive()
    }

    func applicationWillResignActive() {
        self.myListRouter.applicationWillResignActive()
    }
}

// MARK: -
// MARK: UIApplicationDelegate
extension ApplicationRouter {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

// MARK: -
// MARK: Private
private extension ApplicationRouter {
    func showLogin(from window: UIWindow) {
        let navVC = UINavigationController()
        navVC.isNavigationBarHidden = true
        window.rootViewController = navVC
        self.navigationController = navVC
        window.makeKeyAndVisible()

        self.showAuthStory(animated: true)
    }

    func showAuthStory(animated: Bool, completion: VoidBlock? = nil) {
        self.authRouter.show(from: self.navigationController, animated: true)
        if let requiredCompletion = completion { requiredCompletion() }
    }

    private func removeVoiceInputViewController() {
        var viewControllers = self.navigationController.viewControllers
        for (index, element) in viewControllers.enumerated() where element as? VoiceInputViewController != nil {
            viewControllers.remove(at: index)
            self.navigationController.setViewControllers(viewControllers, animated: true)
            break
        }
    }

    private func removePlayerViewController() {
        var viewControllers = self.navigationController.viewControllers
        for (index, element) in viewControllers.enumerated() where element as? PlayerViewController != nil {
            viewControllers.remove(at: index)
            self.navigationController.setViewControllers(viewControllers, animated: true)
            break
        }
    }
}
