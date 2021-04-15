//
//  ServicesAssembly.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import CoreData

protocol ServicesAssemblyProtocol {
    var coreDataManager: CoreDataManagerProtocol { get }
    var firebaseService: FirebaseServiceProtocol { get }
    var themeSwitcherService: ThemeSwitcherServiceProtocol { get }
    var settingsService: SettingsServiceProtocol { get }
    var profileService: ProfileServiceProtocol { get }
}

class ServicesAssembly: ServicesAssemblyProtocol {
    
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var coreDataManager: CoreDataManagerProtocol = coreAssembly.coreDataManager
    lazy var settingsService: SettingsServiceProtocol = SettingsService(userDefaults: coreAssembly.userDefaultsCore)
    lazy var themeSwitcherService: ThemeSwitcherServiceProtocol = ThemeSwitcherService(dataManager: coreAssembly.dataManager)
    lazy var profileService: ProfileServiceProtocol = ProfileService(dataManager: coreAssembly.dataManager)
    lazy var firebaseService: FirebaseServiceProtocol = FirebaseService(parserService: coreAssembly.firebaseParser,
                                                                        coreDataService: coreDataManager,
                                                                        settingsService: settingsService,
                                                                        profileService: profileService)
}
