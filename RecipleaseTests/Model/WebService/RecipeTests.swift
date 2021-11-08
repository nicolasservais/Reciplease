//
//  RecipeTests.swift
//  RecipleaseTests
//
//  Created by Nicolas SERVAIS on 04/11/2021.
//

import XCTest
@testable import Reciplease


class RecipeTests: XCTestCase {

    func testGetRecipeShouldPostCorrectDataThenCallbackIsNotFailed() {
        // Given
        let session = MockRecipeSession(mockResponse: MockResponse(response: MockResponseData.responseOK, data: MockResponseData.recipeCorrectData))
        let mockingService = ServiceRecipe(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        mockingService.getRecipes(ingredients: "chicken") { result in
            guard case .success(let data) = result else {
                XCTFail("Test getRecipes method with correct data failed.")
                return
            }
        // Then
        XCTAssertTrue(data.hits[0].recipe.label == "Chicken Vesuvioo")
        expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    func testGetRecipeShouldPostInCorrectDataThenCallbackIsFailed() {
        // Given
        let session = MockRecipeSession(mockResponse: MockResponse(response: MockResponseData.responseOK, data: MockResponseData.recipeIncorrectData))
        let mockingService = ServiceRecipe(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        mockingService.getRecipes(ingredients: "chicken") { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getRecipes method with incorrect data failed.")
                return
            }
        // Then
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetRecipeShouldPostBadResponseThenCallbackIsFailed() {
        // Given
        let session = MockRecipeSession(mockResponse: MockResponse(response: MockResponseData.responseKO, data: MockResponseData.recipeCorrectData))
        let mockingService = ServiceRecipe(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        mockingService.getRecipes(ingredients: "chicken") { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getRecipes method with bad response failed.")
                return
            }
        // Then
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    

    func testGetRecipeShouldPostNothingThenCallbackIsFailed() {
        // Given
        let session = MockRecipeSession(mockResponse: MockResponse(response: nil, data: nil))
        let mockingService = ServiceRecipe(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        mockingService.getRecipes(ingredients: "chicken") { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getRecipes method with nothing failed.")
                return
            }
        // Then
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testGetRecipeShouldPostBadQueryThenQueryError() {
        // Given
        let session = MockRecipeSession(mockResponse: MockResponse(response: nil, data: nil))
        let mockingService = ServiceRecipe(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        mockingService.getRecipes(ingredients: "") { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getRecipes method with nothing failed.")
                return
            }
        // Then
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)

        
    }

}
