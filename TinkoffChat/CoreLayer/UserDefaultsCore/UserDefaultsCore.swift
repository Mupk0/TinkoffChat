//
//  UserDefaultsCore.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 06.03.2021.
//

import Foundation

class UserDefaultsCore: UserDefaultsCoreProtocol {
    
    lazy var userDefaults: UserDefaults = {
        let userDefaults = UserDefaults.standard
        return userDefaults
    }()
    
    func getValueToKey(key: String, completion: @escaping (String?) -> Void) {
        let value = userDefaults.string(forKey: key)
        completion(value)
    }
    
    func getValueToKey(key: String) -> String? {
        return userDefaults.string(forKey: key)
    }
    
    func setValueToKey(value: String, key: String) {
        userDefaults.set(value, forKey: key)
    }
}
