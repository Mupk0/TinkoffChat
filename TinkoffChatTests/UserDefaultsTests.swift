//
//  UserDefaultsTests.swift
//  TinkoffChatTests
//
//  Created by Dmitry Kulagin on 03.05.2021.
//

@testable import TinkoffChat
import XCTest

class UserDefaultsTests: XCTestCase {

    func testSaveUserDefaults() throws {
        
        // Arrange
        let userDefaultsMock = UserDefaultsMock()
        let settingsService = SettingsService(userDefaults: userDefaultsMock)
        
        // Act
        settingsService.setDeviceId("1")
        settingsService.setTheme("Classic")
        
        // Assert
        XCTAssertEqual(userDefaultsMock.saveCallsCount, 2)
    }
    
    func testReadUserDefaults() throws {
        
        // Arrange
        let userDefaultsMock = UserDefaultsMock()
        let settingsService = SettingsService(userDefaults: userDefaultsMock)
        
        // Act
        settingsService.getDeviceId()
        settingsService.getCurrentTheme(completion: { _ in })
        
        // Assert
        XCTAssertEqual(userDefaultsMock.readCallsCount, 2)
    }
}
