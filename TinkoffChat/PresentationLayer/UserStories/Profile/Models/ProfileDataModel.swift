//
//  ProfileDataModel.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

protocol ProfileDataModelProtocol {
    func getUserProfile(completionHandler: @escaping (ProfileProtocol?, Error?) -> Void)
    func saveUserProfile(_ profile: ProfileProtocol,
                         completionHandler: @escaping (Error?) -> Void)
}

class ProfileDataModel: ProfileDataModelProtocol {
    
    private let profileService: ProfileServiceProtocol
    
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    func saveUserProfile(_ profile: ProfileProtocol,
                         completionHandler: @escaping (Error?) -> Void) {
        profileService.saveUserProfile(profile,
                                       completionHandler: { error in
                                        completionHandler(error)
                                       })
    }
    
    func getUserProfile(completionHandler: @escaping (ProfileProtocol?, Error?) -> Void) {
        profileService.getUserProfile(completionHandler: { (profile, error) in
            completionHandler(profile, error)
        })
    }
}
