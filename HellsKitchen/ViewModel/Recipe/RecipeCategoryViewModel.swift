//
//  RecipeViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 22/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class RecipeCategoryViewModel {
    var delegate: RecipeCategoryViewController?
    var recipeCategories = [RecipeCategory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

//MARK: - loading core data
extension RecipeCategoryViewModel {
    
    func loadSavedData(completion: @escaping ()-> Void) {
        let request: NSFetchRequest<RecipeCategory> = RecipeCategory.fetchRequest()
        do {
            recipeCategories = try context.fetch(request)
            completion()
        } catch {
            print(error.localizedDescription)
            completion()
        }
    }
    
    func loadDataThatContains(text: String) {
        let request: NSFetchRequest<RecipeCategory> = RecipeCategory.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
        do {
            recipeCategories = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        delegate?.tableView.reloadData()
    }
}

//MARK: - existence core data
extension RecipeCategoryViewModel {
    func doesCategoryExist(for name: String)-> Bool {
        return recipeCategories.contains { (category) -> Bool in
            category.name == name
        }
    }
}

//MARK: - remove from core data
extension RecipeCategoryViewModel {
    func remove(at index: IndexPath) {
        context.delete(recipeCategories[index.row])
        recipeCategories.remove(at: index.row)
        saveChangesInCoreData()
    }
}

//MARK: - save to core data
extension RecipeCategoryViewModel {
    func saveChangesInCoreData() {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
//MARK: - performing request
extension RecipeCategoryViewModel {
    func performRequest(for dishName: String, completion: @escaping (Bool)-> Void) {
        RecipeRepository.getRecipes(for: dishName) { [weak self] (recipes, error) in
            guard let recipes = recipes else {
                print(error?.localizedDescription as Any)
                completion(false)
                return
            }
            self!.assignData(for: recipes) {
                completion(true)
            }
        }
    }
    
    private func categoryExists(with newCategoryName: String)-> Bool {
        return recipeCategories.contains { $0.name == newCategoryName}
    }
    
    private func findCategory(for categoryName: String)->  RecipeCategory?{
        return recipeCategories.first { (category) -> Bool in
            category.name == categoryName
        }
    }
        
    private func doesRecipeExist(for category: RecipeCategory, recipeName: String)-> Bool {
        return (category.recipes?.contains {
            return ($0 as! RecipeModel).label == recipeName })!
    }
    
    private func assignData(for givenRecipes: Recipes, completion: @escaping ()-> Void) {
        if !categoryExists(with: givenRecipes.q) {
            let newCategory = RecipeCategory(context: context)
            var recipeArray = [NSManagedObject]()
            for i in givenRecipes.hits {
                let recipe = RecipeModel(context: context)
                recipe.calories = "\(i.recipe.calories)"
                recipe.imageUrl = i.recipe.image
                recipe.label = i.recipe.label
                recipe.time = "\(i.recipe.totalTime)"
                recipe.url = i.recipe.url
                recipe.calories = "\(Int(i.recipe.calories))"
                recipe.recipeCategory = newCategory
                //Assign ingredient
                var ingredientsArray = [NSManagedObject]()
                for j in i.recipe.ingredients {
                    let ingredient = IngredientModel(context: context)
                    ingredient.name = j.text
                    ingredient.weight = Double(j.weight)
                    ingredient.recipe = recipe
                    ingredientsArray.append(ingredient)
                }
                recipe.ingrendients = NSSet(array: ingredientsArray)
                //Ingredient assigned
                recipeArray.append(recipe)
            }
            newCategory.name = givenRecipes.q
            newCategory.recipes = NSSet(array: recipeArray)
        } else {
            guard let category = findCategory(for: givenRecipes.q) else { return }
            
            for i in givenRecipes.hits {
                if !doesRecipeExist(for: category, recipeName: i.recipe.label) {
                    let recipe = RecipeModel(context: context)
                    recipe.calories = "\(Int(i.recipe.calories))"
                    recipe.imageUrl = i.recipe.image
                    recipe.label = i.recipe.label
                    recipe.time = "\(i.recipe.totalTime)"
                    recipe.url = i.recipe.url
                    recipe.recipeCategory = category
                    //Assign ingredient
                    var ingredientsArray = [NSManagedObject]()
                    for j in i.recipe.ingredients {
                        let ingredient = IngredientModel(context: context)
                        ingredient.name = j.text
                        ingredient.weight = Double(j.weight)
                        ingredient.recipe = recipe
                        ingredientsArray.append(ingredient)
                    }
                    recipe.ingrendients = NSSet(array: ingredientsArray)
                    //Ingredient assigned
                    category.addToRecipes(recipe)
                }
            }
        }
        do {
            try self.context.save()
            completion()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion()
        }
    }
}

//MARK: - performing request-> downloading image
extension RecipeCategoryViewModel {
    func downloadImage(with url: String, for recipe: RecipeModel, completion: @escaping ()-> ()) {
        AF
            .request(url, method:  .get)
            .response {
                response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        recipe.image = data!
                        completion()
                    }
                case .failure(let error):
                    print(error)
                    completion()
                }
        }
    }
}
