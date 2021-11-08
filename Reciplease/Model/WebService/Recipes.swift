//
//  Recipes.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 07/11/2021.
//

import Foundation

///Structure define API Edamam
struct Recipes: Codable {
    let from: Int
    let to: Int
    let count: Int
    struct _links: Codable {
        struct next: Codable {
            let href: String
        }
        let next: next
    }
    let _links: _links
    struct hits: Codable {
        struct recipe: Codable {
            let url: String
            let label: String
            let image: String
            let totalTime: Float
            let yield: Float
            let ingredientLines: [String]
        }
        let recipe: recipe
    }
    let hits: [hits]
}
