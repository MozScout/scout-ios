//
//  ApplicationRouter.swift
//  Scout
//
//

import UIKit

class ApplicationRouter: NSObject {
    
    let applicationAssembly: ApplicationAssemblyProtocol
    
    fileprivate var navigationController: UINavigationController!
    fileprivate var mainRouter: MainRoutingProtocol
    fileprivate var authRouter: AuthRoutingProtocol
    fileprivate var voiceInputRouter: VoiceInputRoutingProtocol
    
    required init(with applicationAssembly: ApplicationAssemblyProtocol) {

        self.applicationAssembly = applicationAssembly
        
        // Routers
        self.mainRouter = applicationAssembly.assemblyMainRouter()
        self.authRouter = applicationAssembly.assemblyAuthRouter()
        self.voiceInputRouter = applicationAssembly.assemblyVoiceInputRouter()
        super.init()
    }
}

// MARK: -
// MARK: ApplicationRouter
extension ApplicationRouter: ApplicationRouterProtocol {
    
    func show(from window: UIWindow) {
        
        self.showLogin(from: window)
    }
    
    func showMain(from window: UIWindow) {
        
        self.showMainScreen(from: window)
    }
}

// MARK: -
// MARK: UIApplicationDelegate
extension ApplicationRouter {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        
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
    
    func showMainScreen(from window: UIWindow) {
        
        let navVC = UINavigationController()
        navVC.isNavigationBarHidden = true
        window.rootViewController = navVC
        self.navigationController = navVC
        window.makeKeyAndVisible()
        
        self.showMainStory(viewController: self.navigationController, animated: true)
    }

    func showMainStory(viewController: UINavigationController, animated: Bool, completion: VoidBlock? = nil) {
        
        self.mainRouter.showMainUIInterface(fromViewController: viewController, animated: false)
        self.mainRouter.showMainUITab(tab: .myList, animated: false)
        self.mainRouter.onMicrophoneButtonTap = { [] in
            self.voiceInputRouter.show(from: self.navigationController, animated: true)
            if let requiredCompletion = completion { requiredCompletion() }
        }
    }
    
    func showAuthStory(animated: Bool, completion: VoidBlock? = nil) {
        
        self.authRouter.show(from: self.navigationController, animated: true)
        if let requiredCompletion = completion { requiredCompletion() }
        }
}
