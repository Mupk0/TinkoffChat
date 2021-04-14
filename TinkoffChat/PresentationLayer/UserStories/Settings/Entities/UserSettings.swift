//
//  UserSettings.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.03.2021.
//

import Foundation

protocol UserSettingsProtocol {
    var currentTheme: String? { get }
}

struct UserSettings: UserSettingsProtocol {
    var currentTheme: String?
}
