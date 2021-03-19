//
//  Settings.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 06.03.2021.
//

import Foundation

private let defaultSettingsKey = "TinkoffChatSettingsKey"

class Settings: Codable {
    
    static let shared = Settings.load()
    
    var themeType: String?
    
    enum CodingKeys: String, CodingKey {
        case themeType
    }
}

extension Settings {

    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: defaultSettingsKey)
        }
    }

    fileprivate static func load() -> Settings {
        if let data = UserDefaults.standard.value(forKey: defaultSettingsKey) as? Data {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Settings.self, from: data) as Settings {
                return decoded
            }
        }
        return Settings()
    }
}
