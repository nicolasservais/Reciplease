//
//  ServiceEdamam.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 12/10/2021.
//

import Alamofire

enum ApiError: Error {
    case noData, incorrectResponse, undecodable
}
protocol NetworkRequest {
    func getRecipes(ingredients: String, completion: @escaping (Result<Recipes, Error>) -> Void)
}
 
class ServiceRecipe: NetworkRequest {
    // MARK: - Singleton pattern
    static var shared = ServiceRecipe()

    private let sessionAF: AlamofireSession
    
    init(session: AlamofireSession = RecipeSession()) {
        self.sessionAF = session
    }
    
// MARK: CallBack

    func getRecipes(ingredients: String, completion: @escaping (Result<Recipes, Error>) -> Void) {
        guard let queryUrl = self.getRecipeURL(query: ingredients) else { return }
        sessionAF.request(with: queryUrl) { responses  in
            DispatchQueue.main.async {
                guard let data = responses.data, responses.error == nil else {
                    completion(.failure(ApiError.noData))
                    return
                }
                guard let response = responses.response , response.statusCode == 200 else {
                    completion(.failure(ApiError.incorrectResponse))
                    return
                }
                do {
                    completion(.success(try JSONDecoder().decode(Recipes.self, from: data)))
                    
                } catch {
                    completion(.failure(ApiError.undecodable))

                }
            }
        }
    }
    /*func createRecipeRequest(query: String) -> URLRequest {
        var request = URLRequest(url: getRecipeURL(query: query))
        request.httpMethod = "GET"
        return request
    }
     */
    func getRecipeURL(query: String) -> URL? {
        var urlComponents = URLComponents()
        if query != "" {
            urlComponents.scheme = "https"
            urlComponents.host = "api.edamam.com"
            urlComponents.path = "/api/recipes/v2"
            urlComponents.queryItems = [
                URLQueryItem(name: "app_id", value: KeyRecipe.edamamApplicationId),
                URLQueryItem(name: "app_key", value: KeyRecipe.edamamApplicationKey),
                URLQueryItem(name: "type", value: "public"),
                URLQueryItem(name: "q", value: query)
            ]
            }
        return urlComponents.url
    }
}

