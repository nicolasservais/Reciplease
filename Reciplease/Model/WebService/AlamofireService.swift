//
//  AlamofireService.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 04/11/2021.
//

import Foundation
import Alamofire

protocol AlamofireSession {
    func request(with url: URL, completion: @escaping (AFDataResponse<Any>) -> Void)
}

final class RecipeSession: AlamofireSession {
    func request(with url: URL, completion: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(url).responseJSON { responseData in
            completion(responseData)
        }
    }
}
