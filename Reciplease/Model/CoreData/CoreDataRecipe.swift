//
//  CoreDataRecipe.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 04/11/2021.
//

import UIKit
import CoreData

class CoredataRecipe {
    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext

    init(coreDataStack: CoreDataStack) {
      
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.viewContext

        NotificationCenter.default.addObserver( self, selector: #selector(addRecipe),
                                                name: Notification.Name(rawValue: "addRecipe"),
                                                object: nil)
        NotificationCenter.default.addObserver( self, selector: #selector(deleteRecipe),
                                                name: Notification.Name(rawValue: "deleteRecipe"),
                                                object: nil)
        NotificationCenter.default.addObserver( self, selector: #selector(existRecipe),
                                                name: Notification.Name(rawValue: "existRecipe"),
                                                object: nil)
    }
    // MARK: Notification
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    // MARK: CoreData
        @objc private func existRecipe(notification: Notification) {
            if let recipe: Recipes.hits.recipe = notification.object as? Recipes.hits.recipe {
                if isRecipeStored(recipe: recipe) {
                    NotificationCenter.default.post(name: Notification.Name("existRecipeInDetail"), object: true)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("existRecipeInDetail"), object: false)
                }
            }
        }
        func getRecipesStored() -> Recipes?{
            let recipes: Recipes
            var hits: [Recipes.hits] = []
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            var ingredientLines: [String] = []
            guard let objects = try? coreDataStack.viewContext.fetch(fetchRequest) else { return nil}
                for object in objects as [Recipe] {
                    
                    let ingredientBoard = object.ingredients!.value(forKey: "ingredient") as! NSSet
                    if let board = ingredientBoard.allObjects as? [String] {
                        ingredientLines = board
                    }
                    let recipe: Recipes.hits.recipe = Recipes.hits.recipe(url:object.urlDirection!, label: object.label!, image: object.image!, totalTime: object.totalTime, yield: Float(object.rating), ingredientLines: ingredientLines)
                    
                    let hit:Recipes.hits = Recipes.hits(recipe: recipe)
                    hits.append(hit)
                    }
                    recipes = Recipes(from: 0, to: 0, count: 0, _links: Recipes._links(next: Recipes._links.next(href: "")), hits: hits)
                return recipes
        }
        @objc private func addRecipe(notification: Notification) {
            if let recipe: Recipes.hits.recipe = notification.object as? Recipes.hits.recipe {
                let recipeData = Recipe(context: coreDataStack.viewContext)
                recipeData.label = recipe.label
                recipeData.totalTime = recipe.totalTime
                recipeData.rating = recipe.yield
                recipeData.image = recipe.image
                recipeData.urlDirection = recipe.url
                for value in recipe.ingredientLines {
                    let ingredientData = Ingredients(context: coreDataStack.viewContext)
                    ingredientData.ingredient = value
                    recipeData.addToIngredients(ingredientData)
                }
                coreDataStack.saveContext()
                if isRecipeStored(recipe: recipe) {
                    NotificationCenter.default.post(name: Notification.Name("validateAddRecipe"), object: recipe)
                }
            }
        }
        @objc private func deleteRecipe(notification: Notification) {
            if let recipe: Recipes.hits.recipe = notification.object as? Recipes.hits.recipe {
                //print("delete recipe to Model: \(recipe)")
                let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
                fetchRequest.predicate = NSPredicate.init(format: "label == %@",recipe.label)
                guard let objects = try? coreDataStack.viewContext.fetch(fetchRequest) else { return }
                    for object in objects {
                        coreDataStack.viewContext.delete(object)
                    }
                    try? coreDataStack.viewContext.save()
                    if !isRecipeStored(recipe: recipe) {
                        NotificationCenter.default.post(name: Notification.Name("validateDeleteRecipe"), object: recipe)
                    }
            }
        }
        func isRecipeStored(recipe: Recipes.hits.recipe) -> Bool {
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            fetchRequest.predicate = NSPredicate.init(format: "label == %@", recipe.label)
            guard let objects = try? coreDataStack.viewContext.fetch(fetchRequest) else { return false }
            return objects.count > 0 ? true : false
        }
}
