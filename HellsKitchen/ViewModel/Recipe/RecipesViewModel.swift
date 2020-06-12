//
//  RecipesViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 22/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class RecipesViewModel {
    var delegate: RecipesViewController?
    var recipes = [RecipeModel]()
    var selectedCategory: RecipeCategory?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

//MARK: -loading images
extension RecipesViewModel {
    func downloadImage(for recipe: RecipeModel, completion: @escaping ()-> ()) {
        AF
            .request(recipe.imageUrl!, method: .get)
            .response {
                response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        recipe.image = data!
                        completion()
                        self.saveData()
                    }
                case .failure(let error):
                    print(error)
                    completion()
                }
        }
    }
}

//MARK: - saving to core data
extension RecipesViewModel {
    func saveData() {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

//MARK: - loading core data
extension RecipesViewModel {
    
    func loadSavedData() {
        let request: NSFetchRequest<RecipeModel> = RecipeModel.fetchRequest()
        request.predicate = NSPredicate(format: "(recipeCategory.name MATCHES %@)", selectedCategory!.name!)
        do {
            recipes = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        delegate?.tableView.reloadData()
    }
    
    func loadDataThatContains(text: String) {
        let request: NSFetchRequest<RecipeModel> = RecipeModel.fetchRequest()
        //label CONTAINS[cd] %@ AND
        request.predicate = NSPredicate(format: "(recipeCategory.name MATCHES %@) AND (label CONTAINS[cd] %@)", selectedCategory!.name!, text)
        do {
            recipes = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        delegate?.tableView.reloadData()
    }
}
