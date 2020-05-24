//
//  RecipeDetailViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 24/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation

class RecipeDetailViewModel {
    var delegate: RecipeDetailViewController?
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
}
