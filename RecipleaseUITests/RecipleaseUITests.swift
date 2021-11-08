//
//  RecipleaseUITests.swift
//  RecipleaseUITests
//
//  Created by Nicolas SERVAIS on 11/10/2021.
//

import XCTest

class RecipleaseUITests: XCTestCase {

    /// To work fine, its necessary to test on iPod touch 7 in portrait mode.
    func testGraphic() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars["Tab Bar"].buttons["Favorites"].tap()
        app.tabBars["Tab Bar"].buttons["Search"].tap()
        app.buttons["search"].tap()
        if app.alerts.element.collectionViews.buttons["OK"].exists { app.tap() }
        app.textFields["ingredient"].tap()
        app.textFields["ingredient"].typeText("salad ")
        app.buttons["addIngredient"].tap()
        if app.alerts.element.collectionViews.buttons["OK"].exists { app.tap() }
        app.textFields["ingredient"].typeText(String(XCUIKeyboardKey.delete.rawValue))
        app.textFields["ingredient"].typeText("salad1")
        app.buttons["addIngredient"].tap()
        if app.alerts.element.collectionViews.buttons["OK"].exists { app.tap() }
        app.textFields["ingredient"].typeText(String(XCUIKeyboardKey.delete.rawValue))
        app.textFields["ingredient"].typeText("NiceFailure")
        app.buttons["addIngredient"].tap()
        XCUIApplication().keyboards.buttons["Return"].tap()
        app.buttons["search"].tap()
        sleep(2)
        if app.alerts.element.collectionViews.buttons["OK"].exists { app.tap() }
        app.buttons["clear"].tap()
                app.textFields["ingredient"].tap()
        app.textFields["ingredient"].typeText("egg")
        XCUIApplication().keyboards.buttons["Return"].tap()
        app.buttons["addIngredient"].tap()
        app.buttons["search"].tap()
        sleep(5)
        app.cells.element(boundBy: 0).tap()
        sleep(1)
        app.scrollViews["scroll"].buttons["starButton"].tap()
        sleep(1)
        app.scrollViews["scroll"].buttons["starButton"].tap()
        sleep(1)
        app.scrollViews["scroll"].buttons["starButton"].tap()
        app.scrollViews["scroll"].swipeUp()
        sleep(3)
        app.tap()
        sleep(1)
        app.cells.element(boundBy: 3).tap()
        sleep(1)
        app.scrollViews["scroll"].buttons["starButton"].tap()
        app.tap()
        sleep(1)
        app.cells.element(boundBy: 0).tap()
        sleep(1)
        app.tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        app.tabBars["Tab Bar"].buttons["Favorites"].tap()
        app.cells.element(boundBy: 0).tap()
        app.scrollViews["scroll"].buttons["starButton"].tap()
        app.tap()
        sleep(1)
        app.cells.element(boundBy: 0).tap()
        app.scrollViews["scroll"].buttons["starButton"].tap()
        app.scrollViews["scroll"].buttons["directionButton"].tap()

    }
}
