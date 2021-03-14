//
//  LoadProfileOperation.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.03.2021.
//

import Foundation

class LoadProfileOperation: Operation {
    private let profileStorage: ProfileStorageProtocol
    private let completionHandler: (Profile?) -> Void
    
    init(profileStorage: ProfileStorageProtocol,
         completionHandler: @escaping (Profile?) -> Void) {
        self.profileStorage = profileStorage
        self.completionHandler = completionHandler
    }
    
    override func main() {
        if isCancelled {
            return
        }
        profileStorage.load { profile in
            self.completionHandler(profile)
        }
    }
}
