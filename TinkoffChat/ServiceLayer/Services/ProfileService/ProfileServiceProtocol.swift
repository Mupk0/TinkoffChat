//
//  ProfileServiceProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

protocol ProfileServiceProtocol {
    func getUserProfile(completionHandler: @escaping (Profile?, Error?) -> Void)
    func saveUserProfile(_ profile: Profile, completionHandler: @escaping (Error?) -> Void)
}
