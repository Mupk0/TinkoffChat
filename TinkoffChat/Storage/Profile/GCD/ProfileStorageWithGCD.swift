//
//  ProfileStorageWithGCD.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.03.2021.
//

import Foundation

class ProfileStorageWithGCD: ProfileStorageProtocol {
    
    private let profileStorage = ProfileFileStorage()
    
    func save(profile: Profile, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            self.profileStorage.save(profile: profile) { completion in
                completionHandler(completion)
            }
        }
    }
    
    func load(completionHandler: @escaping (Profile?) -> Void) {
        self.profileStorage.load { profile in
            completionHandler(profile)
        }
    }
}
