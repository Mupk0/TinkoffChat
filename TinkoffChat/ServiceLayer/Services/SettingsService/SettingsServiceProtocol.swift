//
//  SettingsServiceProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

protocol SettingsServiceProtocol {
    func getCurrentTheme(completion: @escaping (String?) -> Void)
    func setTheme(_ theme: String)
    
    func getDeviceId() -> String?
    func setDeviceId(_ id: String)
}
