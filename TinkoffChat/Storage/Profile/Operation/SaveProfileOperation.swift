//
//  SaveProfileOperation.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.03.2021.
//

import Foundation

class SaveProfileOperation: Operation {
    private let profile: Profile
    private let completionHandler: (Bool) -> Void
    private let profileStorage: ProfileStorageProtocol
    
    init(userProfile: Profile,
         profileStorage: ProfileStorageProtocol,
         completionHandler: @escaping (Bool) -> Void) {
        self.profile = userProfile
        self.profileStorage = profileStorage
        self.completionHandler = completionHandler
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        profileStorage.save(profile) { status in
            self.completionHandler(status)
        }
    }
}
