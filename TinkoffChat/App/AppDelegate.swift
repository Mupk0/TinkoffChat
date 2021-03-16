//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 11.02.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Log.show(message: "\(getTransitionInfo()), calls")
        
        window = UIWindow(frame: UIScreen.main.bounds)


        
        let chatListViewController = ConversationsListViewController()
        window?.rootViewController = UINavigationController(rootViewController: chatListViewController)
        window?.makeKeyAndVisible()
        
        let themeStorage = UserSettingsStorageWithGCD()
        themeStorage.load(completionHandler: { userTheme in
            let themeType = ThemeType.init(userTheme?.currentTheme)
            ThemeSwitcher.shared.setTheme(themeType)
        })
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        Log.show(message: "\(getTransitionInfo()), calls")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Log.show(message: "\(getTransitionInfo()), calls")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Log.show(message: "\(getTransitionInfo()), calls")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Log.show(message: "\(getTransitionInfo()), calls")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Log.show(message: "\(getTransitionInfo()), calls")
    }
}

extension AppDelegate {
    
    private func getTransitionInfo(method: String = #function) -> String {
        
        let fromState: String
        let toState: String
        
        switch method {
        case "application(_:didFinishLaunchingWithOptions:)":
            fromState = "not running"
            toState = getStateDescription()
        case "applicationWillResignActive(_:)":
            fromState = getStateDescription()
            toState = "background"
        case "applicationDidEnterBackground(_:)":
            fromState = "active"
            toState = getStateDescription()
        case "applicationWillEnterForeground(_:)":
            fromState = getStateDescription()
            toState = "active"
        case "applicationDidBecomeActive(_:)":
            fromState = "background"
            toState = getStateDescription()
        case "applicationWillTerminate(_:)":
            fromState = getStateDescription()
            toState = "not running"
        default:
            fromState = "unknown"
            toState = "unknown"
        }

        return "Application moved from \(fromState) to \(toState)"
    }
    
    private func getStateDescription() -> String {
        
        let stateValue = UIApplication.shared.applicationState.rawValue

        switch stateValue {
        case 0:
            return "active"
        case 1:
            return "inactive"
        case 2:
            return "background"
        default:
            return "unknown"
        }
    }
}
