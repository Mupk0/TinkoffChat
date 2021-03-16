//
//  UserSettingsStorageWithGCD.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.03.2021.
//

import Foundation

class UserSettingsStorageWithGCD: SettingsStorageProtocol {
    
    private let themeStorage = UserSettingsFileStorage()
    
    func save(model: UserSettings, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            self.themeStorage.save(model: model) { completion in
                completionHandler(completion)
            }
        }
    }
    
    func load(completionHandler: @escaping (UserSettings?) -> Void) {
        self.themeStorage.load { profile in
            completionHandler(profile)
        }
    }
}
