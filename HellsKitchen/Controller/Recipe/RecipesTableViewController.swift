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
        
        let recipe = viewModel.recipes[indexPath.row]
       // cell.textLabel?.text = recipe.label
        return cell
    }


}

extension RecipesTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        viewModel.loadSavedData()
        viewModel.performRequest(for: searchBarText)
    }
}
