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

    required init(with applicationAssembly: ApplicationAssemblyProtocol) {

        self.applicationAssembly = applicationAssembly
        
        // Routers
        self.mainRouter = applicationAssembly.assemblyMainRouter()
        
        super.init()
    }
}

// MARK: -
// MARK: ApplicationRouter
extension ApplicationRouter: ApplicationRouterProtocol {
    
    func show(from window: UIWindow) {
        
        self.showInitialUI(from: window)
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
    
    func showInitialUI(from window: UIWindow) {
        
        let navVC = UINavigationController()
        navVC.isNavigationBarHidden = true
        window.rootViewController = navVC
        self.navigationController = navVC
        window.makeKeyAndVisible()

        self.showMainStory(animated: true)
    }

    func showMainStory(animated: Bool, completion: VoidBlock? = nil) {
        
        self.mainRouter.show(from: self.navigationController, animated: false)
        if let requiredCompletion = completion { requiredCompletion() }
    }
}
