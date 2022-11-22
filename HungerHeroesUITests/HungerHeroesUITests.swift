//
//  HungerHeroesUITests.swift
//  HungerHeroesUITests
//
//  Created by onegray on 3.08.22.
//

import XCTest

class HungerHeroesUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["ui-testing"]
        app.launch()

        let signInBtn = app.buttons["SignIn"]
        XCTAssertTrue(signInBtn.waitForExistence(timeout: 0.1))
        signInBtn.tap()

        let viewPlayersBtn = app.buttons["View Players"]
        XCTAssertTrue(viewPlayersBtn.waitForExistence(timeout: 0.1))
        viewPlayersBtn.tap()

        let gameTitleLabel = app.staticTexts["Free For All"]
        XCTAssertTrue(gameTitleLabel.waitForExistence(timeout: 0.1))

        let playerCell = app.staticTexts["Player1"]
        XCTAssertTrue(playerCell.waitForExistence(timeout: 0.1))
        playerCell.tap()
    }

}
