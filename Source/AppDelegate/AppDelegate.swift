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
    let keychainService: KeychainService

    override init() {

        let configuration = AppConfiguration()
        self.applicationAssembly = ApplicationAssembly(with: configuration)
        self.applicationRouter = ApplicationRouter(with: self.applicationAssembly)
        self.keychainService = self.applicationAssembly.assemblyKeychainService() as! KeychainService
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let result = self.applicationRouter.application!(application, didFinishLaunchingWithOptions: launchOptions)
        if keychainService.value(for: "userID") != nil {
            self.setupMainScreen()
        } else {
            self.setupWindow()
        }

        return result
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
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

        if keychainService.value(for: "userID") != nil {
            var mainRouter = self.applicationAssembly.assemblyMainRouter()
            mainRouter.userID = keychainService.value(for: "userID")!
        }

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        self.window = window

        self.applicationRouter.showMain(from: window)

        UIApplication.shared.statusBarStyle = .default
    }
}
