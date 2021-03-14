//
//  Profile.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.03.2021.
//

import UIKit

class Profile {
    var about: String?
    var photo: UIImage?
    var userName: String?
    
    init(about: String? = nil,
         photo: UIImage? = nil,
         userName: String? = nil) {
        self.about = about
        self.photo = photo
        self.userName = userName
    }
}

extension Profile: Equatable {
    static func ==(lhs: Profile, rhs: Profile) -> Bool {
        return lhs.about == rhs.about && lhs.photo == rhs.photo && lhs.userName == rhs.userName
    }
}
