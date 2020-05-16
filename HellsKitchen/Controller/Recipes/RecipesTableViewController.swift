//
//  RecipesTableViewController.swift
//  HellsKitchen
//
//  Created by Aleksandra Brzostek on 5/16/20.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class RecipesTableViewController: UITableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //how to get only one value from struct?
    var listOfRecipes = [RecipeClass]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.listOfRecipes.count) recipes found"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfRecipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let recipe = listOfRecipes[indexPath.row]
        
        cell.textLabel?.text = recipe.label
        //if we want to add more information:
        //cell.detailTextLabel?.text = recipe.totalTime
        //+change tableView


        return cell
    }


}

extension RecipesTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        /*
        let recipeRequest = RecipeRequest (recipeCode: searchBarText)
        recipeRequest.getRecipes { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let recipes):
                self?.listOfRecipes = recipes
            }
        }
 */
        
    }
}
