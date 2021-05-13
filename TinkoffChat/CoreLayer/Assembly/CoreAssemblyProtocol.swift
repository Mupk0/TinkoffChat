//
//  CoreAssemblyProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.04.2021.
//

import Foundation

protocol CoreAssemblyProtocol {
    var coreDataStack: CoreDataStackProtocol { get }
    var coreDataManager: CoreDataManagerProtocol { get }
    var dataManager: DataManagerProtocol { get }
    var firebaseParser: FirebaseParserProtocol { get }
    var userDefaultsCore: UserDefaultsCoreProtocol { get }
    var requestSender: RequestSenderProtocol { get }
    var environment: EnvironmentProtocol { get }
}
