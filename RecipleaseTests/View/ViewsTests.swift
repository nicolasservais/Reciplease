//
//  ViewsTests.swift
//  RecipleaseTests
//
//  Created by Nicolas SERVAIS on 08/11/2021.
//

import XCTest
@testable import Reciplease

class ViewsTests: XCTestCase {

    func testInitWithCoderAddIngredientView() {
        let addView = AddIngredientView(coder: NSCoder())
        XCTAssertNil(addView)
    }

}
