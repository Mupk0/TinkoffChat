//
//  ThemesDataModel.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

class ThemesDataModel: ThemesDataModelProtocol {
    
    let themeSwitchService: ThemeSwitcherServiceProtocol
    let settingsService: SettingsServiceProtocol
    
    init(themeSwitchService: ThemeSwitcherServiceProtocol,
         settingsService: SettingsServiceProtocol) {
        
        self.themeSwitchService = themeSwitchService
        self.settingsService = settingsService
    }
    
    func saveTheme(_ theme: String) {
        settingsService.setTheme(theme)
    }
}
