//
//  Recipes.swift
//  HellsKitchen
//
//  Created by Apple on 22/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class RecipesViewController: UITableViewController {
    
    let viewModel: RecipesViewModel = RecipesViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = viewModel.recipes[indexPath.row].label
       // cell.textLabel?.text = recipe.label
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! RecipeDetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            vc.viewModel.recipe = viewModel.recipes[indexPath.row]
            for i in viewModel.recipes[indexPath.row].ingrendients! {
                vc.viewModel.ingredients.append(i as! IngredientModel)
            }
        }
    }
}

extension RecipesViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        //viewModel.loadSavedData()
        //viewModel.performRequest(for: searchBarText)
    }
}
