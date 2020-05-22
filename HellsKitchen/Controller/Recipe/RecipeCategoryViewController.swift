//
//  RecipesTableViewController.swift
//  HellsKitchen
//
//  Created by Aleksandra Brzostek on 5/16/20.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class RecipeCategoryViewController: UITableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //how to get only one value from struct?
    let viewModel: RecipeCategoryViewModel = RecipeCategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView.delegate = self
        viewModel.loadSavedData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipeCategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = viewModel.recipeCategories[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! RecipesViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            for i in viewModel.recipeCategories[indexPath.row].recipes! {
                vc.viewModel.recipes.append(i as! RecipeModel)
            }
        }
    }
    
}

extension RecipeCategoryViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        if searchBarText.count != 0 {
            viewModel.loadSavedData()
            viewModel.performRequest(for: searchBarText)
        }   
    }
}
