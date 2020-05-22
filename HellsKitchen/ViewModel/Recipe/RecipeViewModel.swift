//
//  RecipeViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 22/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import CoreData

class RecipesViewModel {
    var delegate: RecipesTableViewController?
    var recipes = [RecipeModel]()
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

//MARK: - loading core data
extension RecipesViewModel {
    func loadSavedData() {
        let request: NSFetchRequest<RecipeCategory> = RecipeCategory.fetchRequest()
        do {
            let categories = try context.fetch(request)
        } catch {
            
        }
    }
}


//MARK: - performing request
extension RecipesViewModel {
    func performRequest(for dishName: String) {
        RecipeRepository.getRecipes(for: dishName) { [weak self] (recipes, error) in
            guard let recipes = recipes else {
                print(error?.localizedDescription as Any)
                return
            }
            self!.assignData(for: recipes)
        }
    }
    
    private func assignData(for givenRecipes: Recipes) {
        let categoryEntity = NSEntityDescription.entity(forEntityName: "RecipeCategory", in: context)!
        let recipeEntity = NSEntityDescription.entity(forEntityName: "RecipeModel", in: context)!
        let category = NSManagedObject(entity: categoryEntity, insertInto: context)

        var formattedRecipes = [NSManagedObject]()
        for i in givenRecipes.hits {
            let recipe = NSManagedObject(entity: recipeEntity, insertInto: context)
            recipe.setValue( "\(i.recipe.calories)", forKey: "calories")
            recipe.setValue( i.recipe.image, forKey: "image")
            recipe.setValue( i.recipe.label, forKey: "label")
            recipe.setValue( "\(i.recipe.totalTime)", forKey: "time")
            recipe.setValue( i.recipe.url, forKey: "url")
            recipe.setValue(category, forKey: "recipeCategory")
            formattedRecipes.append(recipe)
        }
        
        category.setValue(givenRecipes.q, forKeyPath: "name")
        category.setValue(NSSet(array: formattedRecipes), forKeyPath: "recipes")
        // 4
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
