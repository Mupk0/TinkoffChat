//
//  SettingsService.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

class SettingsService: SettingsServiceProtocol {
    
    private let themeKey = "CurrentTheme"
    private let userDeviceKey = "UserDevice"
    
    private let userDefaults: UserDefaultsCoreProtocol
    
    init(userDefaults: UserDefaultsCoreProtocol) {
        self.userDefaults = userDefaults
    }
    
    func getCurrentTheme(completion: @escaping (String?) -> Void) {
        userDefaults.getValueToKey(key: themeKey,
                                   completion: { theme in
                                    completion(theme)
                                   })
    }
    
    func setTheme(_ theme: String) {
        userDefaults.setValueToKey(value: theme, key: themeKey)
    }
    
    func getDeviceId() -> String? {
        return userDefaults.getValueToKey(key: userDeviceKey)
    }
    
    func setDeviceId(_ id: String) {
        userDefaults.setValueToKey(value: id, key: userDeviceKey)
    }
}
