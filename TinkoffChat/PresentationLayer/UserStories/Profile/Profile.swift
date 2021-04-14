//
//  Profile.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.03.2021.
//

import UIKit

protocol ProfileProtocol: Codable {
    var about: String? { get }
    var photo: Data? { get }
    var userName: String? { get }
    
    func isEquatable(newValue: ProfileProtocol?) -> Bool
}

struct Profile: ProfileProtocol {
    var about: String?
    var photo: Data?
    var userName: String?
    
    init(about: String? = nil,
         photo: Data? = nil,
         userName: String? = nil) {
        self.about = about
        self.photo = photo
        self.userName = userName
    }
    
    func isEquatable(newValue: ProfileProtocol?) -> Bool {
        return self.about == newValue?.about && self.photo == newValue?.photo && self.userName == newValue?.userName
    }
}
