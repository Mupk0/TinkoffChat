//
//  Environment.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 12.05.2021.
//

import Foundation

class Environment: EnvironmentProtocol {
    
    private let infoDictionary: [String: Any]
    
    init() {
        guard let dict = Bundle.main.infoDictionary else {
          fatalError("Info Plist File not found")
        }
        infoDictionary = dict
    }

    func getValueForProperties(_ properties: PrivateProperties) -> String {
        guard let property = infoDictionary[properties.rawValue] as? String else {
            fatalError("\(properties.rawValue) not set in plist for this environment")
        }
        guard !property.isBlank else {
            fatalError("\(properties.rawValue) not set in Config file")
        }
        return property
    }
}
