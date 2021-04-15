//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

class CoreAssembly: CoreAssemblyProtocol {
    
    lazy var dataManager: DataManagerProtocol = DataManager()
    lazy var coreDataStack: CoreDataStackProtocol = CoreDataStack.shared
    lazy var coreDataManager: CoreDataManagerProtocol = CoreDataManager(coreDataStack: coreDataStack)
    lazy var firebaseParser: FirebaseParserProtocol = FirebaseParser(coreDataService: coreDataManager)
    lazy var userDefaultsCore: UserDefaultsCoreProtocol = UserDefaultsCore()
}
