//
//  TinkoffChatUITests.swift
//  TinkoffChatUITests
//
//  Created by Dmitry Kulagin on 03.05.2021.
//

import XCTest

class TinkoffChatUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }

    func testProfileViewController() throws {
        let app = XCUIApplication()
        app.launch()
        
        let profileButton = app.navigationBars.buttons["ProfileButton"].firstMatch
        let profileButtonExistens = profileButton.waitForExistence(timeout: 5.0)
        
        XCTAssertTrue(profileButtonExistens)
        profileButton.tap()
        
        let nameTextField = app.textFields["UserNameTextField"].firstMatch
        let nameTextFieldExistens = nameTextField.waitForExistence(timeout: 5.0)
        let descriptionTextView = app.textViews["UserDescriptionTextView"].firstMatch
        let descriptionTextViewExistens = descriptionTextView.waitForExistence(timeout: 5.0)
        
        XCTAssertTrue(nameTextFieldExistens)
        XCTAssertTrue(descriptionTextViewExistens)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
