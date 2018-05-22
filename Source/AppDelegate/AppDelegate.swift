//
//  AppDelegate.swift
//  Scout
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let applicationRouter: ApplicationRouterProtocol
    let applicationAssembly: ApplicationAssemblyProtocol

    override init() {
        
        let configuration = AppConfiguration()
        self.applicationAssembly = ApplicationAssembly(with: configuration)
        self.applicationRouter = ApplicationRouter(with: self.applicationAssembly)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let result = self.applicationRouter.application!(application, didFinishLaunchingWithOptions: launchOptions)
        self.setupWindow()

        self.applicationAssembly.assemblyKeychainService()
        return result
    }
    
    func application(_ application: UIApplication, open url: URL,
                     sourceApplication: String?, annotation: Any) -> Bool {
        var mainRouter = self.applicationAssembly.assemblyMainRouter()
        mainRouter.userID = url.lastPathComponent
        
        self.setupMainScreen()
        return true
    }
}

// MARK: -
// MARK: Private
fileprivate extension AppDelegate {
    
    func setupWindow() {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        self.window = window
        
        self.applicationRouter.show(from: window)

        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupMainScreen() {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        self.window = window
        
        self.applicationRouter.showMain(from: window)
        
        UIApplication.shared.statusBarStyle = .default
    }
}
