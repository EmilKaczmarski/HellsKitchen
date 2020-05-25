//
//  RecipesTableViewController.swift
//  HellsKitchen
//
//  Created by Aleksandra Brzostek on 5/16/20.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import SwipeCellKit

class RecipeCategoryViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //how to get only one value from struct?
    let viewModel: RecipeCategoryViewModel = RecipeCategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView.delegate = self
        tableView.rowHeight = 70.0
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cell")
        viewModel.loadSavedData()
    }
    
//MARK: - tableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipeCategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = viewModel.recipeCategories[indexPath.row].name
        return cell
    }
 //MARK: - swipe cell methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
              self.updateModel(at: indexPath)
              
          }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        return options
    }
    
    func updateModel(at index: IndexPath) {
        viewModel.remove(at: index)
    }

//MARK: - segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! RecipesViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            for i in viewModel.recipeCategories[indexPath.row].recipes! {
                vc.viewModel.recipes.append(i as! RecipeModel)
            }
            vc.viewModel.selectedCategory = viewModel.recipeCategories[indexPath.row]
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segues.recipeCetegorySegue, sender: self)
    }
    
}

//MARK: - search bar methods
extension RecipeCategoryViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchBarText = searchBar.text else { return }

        if searchBarText.count != 0 {
            viewModel.loadDataThatContains(text: searchBarText)
        } else {
            viewModel.loadSavedData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        if searchBarText.count != 0 {
            viewModel.loadSavedData()
            viewModel.performRequest(for: searchBarText)
        }   
    }
}
