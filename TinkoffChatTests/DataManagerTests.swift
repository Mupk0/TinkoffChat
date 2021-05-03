//
//  DataManagerTests.swift
//  TinkoffChatTests
//
//  Created by Dmitry Kulagin on 03.05.2021.
//

@testable import TinkoffChat
import XCTest

class DataManagerTests: XCTestCase {
    
    func testSaveDataManager() throws {
        
        // Arrange
        let dataManagerMock = DataManagerMock()
        let profileService = ProfileService(dataManager: dataManagerMock)
        let profileMock = Profile(about: "Some Text", photo: nil, userName: "Some Text")
        
        // Act
        profileService.saveUserProfile(profileMock, completionHandler: { _ in })
        
        // Assert
        XCTAssertEqual(dataManagerMock.saveCallsCount, 1)
    }
    
    func testReadDataManager() throws {
        
        // Arrange
        let dataManagerMock = DataManagerMock()
        let profileService = ProfileService(dataManager: dataManagerMock)
        
        // Act
        profileService.getUserProfile(completionHandler: { _, _  in })
        
        // Assert
        XCTAssertEqual(dataManagerMock.readCallsCount, 1)
    }
}
