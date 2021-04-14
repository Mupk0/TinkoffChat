//
//  ProfileService.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

class ProfileService: ProfileServiceProtocol {
    
    private let userProfileKey = "UserProfile"
    
    let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func getUserProfile(completionHandler: @escaping (Profile?, Error?) -> Void) {
        dataManager.load(Profile.self,
                         from: userProfileKey,
                         completionHandler: { (profile, error) in
                            if let error = error {
                                print(error)
                                completionHandler(nil, error)
                            }
                            if let profile = profile {
                                completionHandler(profile, nil)
                            }
                         })
    }
    
    func saveUserProfile(_ profile: Profile,
                         completionHandler: @escaping (Error?) -> Void) {
        dataManager.save(profile,
                         to: userProfileKey,
                         completionHandler: { error in
                            if let error = error {
                                print(error)
                                completionHandler(error)
                            }
                         })
    }
}
