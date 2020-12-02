//
//  ProfileUITests.swift
//  ChatUITests
//
//  Created by Anastasia Shmakova on 02.12.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import XCTest

class ProfileUITests: XCTestCase {

    func testProfileInputs() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars.buttons["profile_button"].tap()
        app.navigationBars.buttons["profile_edit_button"].tap()
        XCTAssert(app.textFields["profile_name_text_field"].exists)
        XCTAssert(app.textViews["profile_info_text_view"].exists)
    }
}
