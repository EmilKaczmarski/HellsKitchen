//
//  RecipeDetailViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 24/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import CoreData

class RecipeDetailViewModel {
    var delegate: RecipeDetailViewController?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var ingredients = [IngredientModel]() {
        didSet {
            delegate?.tableView.reloadData()
        }
    }
    var recipe: RecipeModel?
    
    func setupData() {
        delegate?.name.text = recipe?.label
        delegate?.time.text = recipe?.time
        delegate?.calories.text = recipe?.calories
        delegate?.url.text = recipe?.url
    }
    
    func saveImage(data: Data) {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
