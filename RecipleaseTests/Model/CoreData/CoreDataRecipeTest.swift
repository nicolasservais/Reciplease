//
//  CoreDataRecipeTest.swift
//  RecipleaseTests
//
//  Created by Nicolas SERVAIS on 06/11/2021.
//


import XCTest
@testable import Reciplease

class CoreDataRecipeTest: XCTestCase {
    
    var coreDataStack: MockCoreDataStack!
    var coreDataRecipe: CoredataRecipe!

    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack(modelName: "Reciplease")
        coreDataRecipe = CoredataRecipe(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        //super.tearDown()
        coreDataRecipe = nil
        coreDataStack = nil
    }
    func testGetRecipeShouldRecordingNewRecipeThenCorrectSaving() {
        do {
            let data = MockResponseData.recipeCorrectData
            let recipe = try JSONDecoder().decode(Recipes.self, from: data!)
            NotificationCenter.default.post(name: Notification.Name("addRecipe"), object: recipe.hits[0].recipe)

            let recipes = coreDataRecipe.getRecipesStored()
            let emptyRecipes = Recipes.hits.recipe(url: "", label: "empty", image: "", totalTime: 0, yield: 0, ingredientLines: [])

            NotificationCenter.default.post(name: Notification.Name("existRecipe"), object: recipe.hits[0].recipe)

            
            XCTAssertTrue(coreDataRecipe.isRecipeStored(recipe: recipe.hits[0].recipe))
            XCTAssertEqual(recipes!.hits.count, 1)
            XCTAssertFalse(coreDataRecipe.isRecipeStored(recipe: emptyRecipes))
        }
        catch {
            XCTFail("Test getRecipe in CoreDataRecipeTest method with correct Data failed.")
        }
    }
    func testGetRecipeShouldDeleteNewRecipeThenCorrectSaving() {
        do {
            //add one recipe
            let data = MockResponseData.recipeCorrectData
            let recipe = try JSONDecoder().decode(Recipes.self, from: data!)
            NotificationCenter.default.post(name: Notification.Name("addRecipe"), object: recipe.hits[0].recipe)
            XCTAssertTrue(coreDataRecipe.isRecipeStored(recipe: recipe.hits[0].recipe))
            
            //delete one recipe
            NotificationCenter.default.post(name: Notification.Name("deleteRecipe"), object: recipe.hits[0].recipe)
            NotificationCenter.default.post(name: Notification.Name("existRecipe"), object: recipe.hits[0].recipe)
            XCTAssertFalse(coreDataRecipe.isRecipeStored(recipe: recipe.hits[0].recipe))
        }
        catch {
            XCTFail("Test getRecipe in CoreDataRecipeTest method with correct Data failed.")
        }
    }
}
