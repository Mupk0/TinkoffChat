//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 11.02.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let rootAssembly = RootAssembly()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootViewController = rootAssembly.presentationAssembly.conversationsListViewController()
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
        
//        let themeStorage = UserSettingsFileStorage()
//        themeStorage.load(completionHandler: { userTheme in
//            let themeType = ThemeType(userTheme?.currentTheme)
//            ThemeSwitcher.shared.setTheme(themeType)
//        })
//
//        if Settings.shared.deviceId == nil {
//            if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
//                Settings.shared.deviceId = deviceId
//                Settings.shared.save()
//            }
//        }
        
        return true
    }
}
