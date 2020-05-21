//
//  RecipeRequest.swift
//  HellsKitchen
//
//  Created by Aleksandra Brzostek on 5/15/20.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation

enum RecipeError:Error {
    case noDataAvailable
}

struct RecipeRequest {
    let resourceURL:URL
    let API_KEY = "b935146b5a9ff574407ec5b199899a6c"
    let API_ID = "8e701985"
    
    init(recipeCode:String) {
        
        let resourceString =
        "https://api.edamam.com/search?q=\(recipeCode)&app_id=\(API_ID)&app_key=\(API_KEY)"
        
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    /*
    //i will fix it
    
    func getRecipes (completion: @escaping(Result<RecipeClass>, RecipeError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL)
        {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let recipesResponse = try decoder.decode(Hit.self, from: jsonData)
                let recipeClasses = recipesResponse.response.recipes
                completion(.success(recipeClasses))
            }
            catch{
                completion(.failure(.noDataAvailable))
            }
            
        }
        dataTask.resume()
    }
 
 */

}
