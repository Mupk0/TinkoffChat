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
    
    var coreDataStack = CoreDataStack.shared

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)

        let chatListViewController = ConversationsListViewController()
        window?.rootViewController = UINavigationController(rootViewController: chatListViewController)
        window?.makeKeyAndVisible()
        
        let themeStorage = UserSettingsStorageWithGCD()
        themeStorage.load(completionHandler: { userTheme in
            let themeType = ThemeType(userTheme?.currentTheme)
            ThemeSwitcher.shared.setTheme(themeType)
        })
        
        if Settings.shared.deviceId == nil {
            if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
                Settings.shared.deviceId = deviceId
                Settings.shared.save()
            }
        }
        
        /*
         coreDataStack.didUpdateDataBase = { stack in
             stack.printDatabaseStatistice()
         }
         
         coreDataStack.enableObservers()
         */
        
        return true
    }
}
