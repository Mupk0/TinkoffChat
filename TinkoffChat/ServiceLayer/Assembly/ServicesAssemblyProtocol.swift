//
//  ServicesAssemblyProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.04.2021.
//

import Foundation

protocol ServicesAssemblyProtocol {
    var coreDataManager: CoreDataManagerProtocol { get }
    var firebaseService: FirebaseServiceProtocol { get }
    var themeSwitcherService: ThemeSwitcherServiceProtocol { get }
    var settingsService: SettingsServiceProtocol { get }
    var profileService: ProfileServiceProtocol { get }
}
