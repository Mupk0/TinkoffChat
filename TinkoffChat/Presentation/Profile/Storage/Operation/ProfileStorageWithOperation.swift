//
//  ProfileStorageWithOperation.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.03.2021.
//

import Foundation

class ProfileStorageWithOperation: ProfileStorageProtocol {
    private let queue = OperationQueue()
    private let profileStorage = ProfileFileStorage()
    
    func save(profile: Profile,
              completionHandler: @escaping (Bool) -> Void) {
        let operation = SaveProfileOperation(userProfile: profile,
                                             profileStorage: profileStorage,
                                             completionHandler: completionHandler)
        queue.addOperation(operation)
    }
    
    func load(completionHandler: @escaping (Profile?) -> Void) {
        let operation = LoadProfileOperation(profileStorage: profileStorage,
                                             completionHandler: completionHandler)
        queue.addOperation(operation)
    }
}
