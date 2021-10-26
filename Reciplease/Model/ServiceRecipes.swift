//
//  ServiceEdamam.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 12/10/2021.
//

import Foundation

///Structure define API Edamam
struct Recipes: Codable {
    let from: Int
    let to: Int
    let count: Int
    struct _links: Codable {
        struct next: Codable {
            let href:String
        }
        let next: next
    }
    let _links: _links
    struct hits: Codable {
        struct recipe: Codable {
            let label: String
            let image: String
            let totalTime: Float
            let yield: Float
        }
        let recipe: recipe
    }
    let hits: [hits]
    
}

final class ServiceRecipes {
    
    // MARK: - Singleton pattern
    static var shared = ServiceRecipes()
    private init() {}

    private var task: URLSessionDataTask?
    private var recipeSession = URLSession(configuration: .default)

    init(urlSession: URLSession) {
        recipeSession = urlSession
    }

    func getRecipes(query: String, callback: @escaping (Bool, Recipes?) -> Void) {
        let request: URLRequest = createRecipeRequest(query: query)
        task?.cancel()
        task = recipeSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("ERROR 1")
                    callback(false,nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("ERROR 2")
                    callback(false,nil)
                    return
                }
                let jsonDecoder = JSONDecoder()
                do {
                    //let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                    //print("reccipes data Change: \(string1)")

                    let parsedJSON = try jsonDecoder.decode(Recipes.self, from: data)
                    
                    /*let recipes: Recipes = Recipes(from: parsedJSON.from, to: parsedJSON.to, count: parsedJSON.count, _links: parsedJSON._links, hits: parsedJSON.hits)
                     */
                    //let str = String("from: \(parsedJSON.from) to: \(parsedJSON.to) count: \(parsedJSON.count)")
                    //let recipes: Recipes = Recipes(from: parsedJSON.from, to: parsedJSON.to, count: parsedJSON.count, href: parsedJSON.href, hits: parsedJSON.hits)
                    
                    callback(true, parsedJSON)
                    return
                } catch {
                    print("ERROR 3")
                    callback(false, nil)
                    return
                    }
               }
        }
        task?.resume()
    }
    private func createRecipeRequest(query: String) -> URLRequest {
        var request = URLRequest(url: getRecipeURL(query: query))
        request.httpMethod = "GET"
        return request
    }
    private func getRecipeURL(query: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.edamam.com"
        urlComponents.path = "/api/recipes/v2"
        urlComponents.queryItems = [
            URLQueryItem(name: "app_id", value: KeyRecipe.edamamApplicationId),
            URLQueryItem(name: "app_key", value: KeyRecipe.edamamApplicationKey),
            URLQueryItem(name: "type", value: "public"),
            URLQueryItem(name: "q", value: query)
        ]
        guard let url = urlComponents.url else {
            fatalError("Could not create URL from components")
        }
        return url
    }
}
