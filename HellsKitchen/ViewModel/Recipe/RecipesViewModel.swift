//
//  RecipesViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 22/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import CoreData
class RecipesViewModel {
    var delegate: RecipesViewController?
    var recipes = [RecipeModel]()
    var selectedCategory: RecipeCategory?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

//MARK: - loading core data
extension RecipesViewModel {
    
    func loadSavedData() {
        let request: NSFetchRequest<RecipeModel> = RecipeModel.fetchRequest()
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
