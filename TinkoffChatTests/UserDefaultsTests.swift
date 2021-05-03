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
        
        // Assert
        XCTAssertEqual(userDefaultsMock.saveCallsCount, 1)
    }
    
    func testReadUserDefaults() throws {
        
        // Arrange
        let userDefaultsMock = UserDefaultsMock()
        let settingsService = SettingsService(userDefaults: userDefaultsMock)
        
        // Act
        settingsService.getCurrentTheme(completion: { _ in })
        
        // Assert
        XCTAssertEqual(userDefaultsMock.readCallsCount, 1)
    }
}
