//
//  MockResponseData.swift
//  RecipleaseTests
//
//  Created by Nicolas SERVAIS on 04/11/2021.
//

import Foundation


class MockResponseData {

// MARK: - Bad Json Data
    static var recipeBadData: Data? {
        let bundle = Bundle(for: MockResponseData.self)
        let url = bundle.url(forResource: "RecipesRessourceBad", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
// MARK: - Good Json Data
    static var recipeCorrectData: Data? {
        let bundle = Bundle(for: MockResponseData.self)
        let url = bundle.url(forResource: "RecipesRessource", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    static let recipeIncorrectData = "erreur".data(using: .utf8)!
// MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
// MARK: - Error
    class RecipeError: Error {}
    static let recipeError = RecipeError()
}
