//
//  ControllersTests.swift
//  RecipleaseTests
//
//  Created by Nicolas SERVAIS on 07/11/2021.
//

import XCTest
@testable import Reciplease

class ControllersTests: XCTestCase {

    
    func testInitWithCoderTabViewController() {
        let tabView = TabViewController(coder: NSCoder())
        XCTAssertNil(tabView)
    }
    func testInitWithCoderNavigationController() {
        let navView = NavigationController(coder: NSCoder())
        XCTAssertNil(navView)
    }
    func testInitWithCoderSearchViewController() {
        let searchView = SearchViewController(coder: NSCoder())
        XCTAssertNil(searchView)
    }
    func testInitWithCoderListIngredientController() {
        let listView = ListIngredientView(coder: NSCoder())
        XCTAssertNil(listView)
    }
    func testInitWithCoderCellRecipeController() {
        let cellView = CellRecipe(coder: NSCoder())
        XCTAssertNil(cellView)
    }
    func testInitWithCoderDetailController() {
        let detailView = DetailRecipeViewController(coder: NSCoder())
        XCTAssertNil(detailView)
    }
    func testInitWithCoderListRecipeController() {
        let list = ListRecipesTableViewController(coder: NSCoder())
        XCTAssertNil(list)
    }
}
