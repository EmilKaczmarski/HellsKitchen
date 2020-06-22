//
//  RecipeRequest.swift
//  HellsKitchen
//
//  Created by Aleksandra Brzostek on 5/15/20.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import Alamofire

enum RecipeAPI {
    
    case recipe(String)
    
    var path: String {
        return "https://api.edamam.com/search"
    }
    
    var url: URL? {
        return URL(string: path)
    }
    var parameters: Parameters {
        var params = [
            "app_id": "ebf7a149",
            "app_key": "7c16969e65ab79d0850f22e346f5eed7",
            "from": "0",
            "to": "3"
        ]
        switch self {
        case .recipe(let recipe):
            params["q"] = recipe
        }
        return params
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
}

struct RecipeRepository {
    
    static func getRecipes(for dishName: String, completion: @escaping ((Recipes?, Error?)-> Void)) {
        executeRequest(.recipe(dishName), completion: completion)
    }
    
    private static func executeRequest<T: Codable>(_ request: RecipeAPI, completion: @escaping((T?, Error?)-> Void)) {
        guard let requestUrl = request.url else { return }
        AF  .request(requestUrl,
                     method: request.method,
                     parameters: request.parameters)
            .response { response in
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let responseObject: T = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
        }
    }
}
