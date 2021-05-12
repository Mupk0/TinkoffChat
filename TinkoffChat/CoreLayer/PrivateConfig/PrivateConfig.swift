//
//  PrivateConfig.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 12.05.2021.
//

import Foundation

class PrivateConfig: PrivateConfigProtocol {
    
    func getValueForProperties(_ properties: PrivateProperties) -> String? {
        let privateConfig = getPrivateConfig()
        if let property = privateConfig[properties.rawValue] as? String {
            if !property.isBlank {
                return property.replacingOccurrences(of: "\"", with: "")
            }
        }
        return nil
    }
    
    private func getPrivateConfig() -> [String: Any] {
        if let plist = getInfoPlist() {
            if let privacy = plist["Private Properties"] as? [String: Any] {
                return privacy
            }
        }
        return [:]
    }
    
    private func getInfoPlist() -> [String: Any]? {
        var config: [String: Any]?
        if let infoPlistPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: infoPlistPath) as? [String: Any] {
            config = dict
        }
        return config
    }
}
