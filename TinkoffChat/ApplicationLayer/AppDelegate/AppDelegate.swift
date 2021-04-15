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
                     willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        let settingsService = rootAssembly.serviceAssembly.settingsService
        
        settingsService.getCurrentTheme(completion: { [weak self] theme in
            let themeType = ThemeType(theme)
            self?.rootAssembly.serviceAssembly.themeSwitcherService.apply(themeType)
        })
        
        if settingsService.getDeviceId() == nil {
            if let id = UIDevice.current.identifierForVendor?.uuidString {
                settingsService.setDeviceId(id)
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = rootAssembly.presentationAssembly.conversationsListViewController()
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
        
        return true
    }
}
