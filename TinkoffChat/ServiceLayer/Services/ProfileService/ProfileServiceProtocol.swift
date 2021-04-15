//
//  ProfileServiceProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

protocol ProfileServiceProtocol {
    func getUserProfile(completionHandler: @escaping (ProfileProtocol?, Error?) -> Void)
    func saveUserProfile(_ profile: ProfileProtocol, completionHandler: @escaping (Error?) -> Void)
}
