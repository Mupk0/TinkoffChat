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
    
    func getUserProfile(completionHandler: @escaping (ProfileProtocol?, Error?) -> Void) {
        dataManager.load(Profile.self,
                         from: userProfileKey,
                         completionHandler: { (profile, error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                            completionHandler(profile, error)
                         })
    }
    
    func saveUserProfile(_ profile: ProfileProtocol,
                         completionHandler: @escaping (Error?) -> Void) {
        let profileModel = Profile(about: profile.about, photo: profile.photo, userName: profile.userName)
        dataManager.save(profileModel,
                         to: userProfileKey,
                         completionHandler: { error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                            completionHandler(error)
                         })
    }
}
