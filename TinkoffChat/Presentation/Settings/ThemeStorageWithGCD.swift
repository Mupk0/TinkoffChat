//
//  ThemeStorageWithGCD.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.03.2021.
//

import Foundation

class ThemeStorageWithGCD: ThemeStorageProtocol {
    
    private let themeStorage = ThemeFileStorage()
    
    func save(userTheme profile: UserTheme, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            self.themeStorage.save(userTheme: profile) { completion in
                completionHandler(completion)
            }
        }
    }
    
    func load(completionHandler: @escaping (UserTheme?) -> Void) {
        self.themeStorage.load { profile in
            completionHandler(profile)
        }
    }
}
