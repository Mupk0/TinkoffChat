//
//  ProfileDataModelProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import Foundation

protocol ProfileDataModelProtocol {
    func getUserProfile(completionHandler: @escaping (ProfileProtocol?, Error?) -> Void)
    func saveUserProfile(_ profile: ProfileProtocol,
                         completionHandler: @escaping (Error?) -> Void)
}
