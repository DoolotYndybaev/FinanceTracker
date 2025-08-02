//
//  FinanceTrackerUITests.swift
//  FinanceTrackerUITests
//
//  Created by Doolot on 2/8/25.
//

import XCTest

final class FinanceTrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOnboardingButtons_shouldBeVisibleAndTappable() {
        let app = XCUIApplication()
        app.launch()

        let getStartedButton = app.buttons["getStartedButton"]
        let loginButton = app.buttons["loginButton"]

        // Ожидаем появления кнопки (Splash может быть первым экраном)
        XCTAssertTrue(getStartedButton.waitForExistence(timeout: 5), "Кнопка 'Get Started' должна быть на экране")
        XCTAssertTrue(loginButton.exists, "Кнопка 'Log In' должна быть на экране")

        // Пробуем тапнуть
        getStartedButton.tap()
    }
}
