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
    var newCategoryName = ""
    //how to get only one value from struct?
    let viewModel: RecipeCategoryViewModel = RecipeCategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView.delegate = self
        tableView.rowHeight = 70.0
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cell")
        viewModel.loadSavedData() {
            self.tableView.reloadData()
        }
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
        //customize the action appearance
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
    
    //MARK: - core data methods
    func performReqest(for name: String) {
        let group = DispatchGroup()
        group.enter()
        let alert = AlertManager.shared.loadingAlert(in: self) {
            group.leave()
        }
        var result = true
        AlertManager.shared.sheduleTimerFor(alert: alert, in: self) { (success) in
            result = success
        }
        viewModel.performRequest(for: name) { success in
            if success {
                self.viewModel.loadSavedData {
                    self.tableView.reloadData()
                    self.newCategoryName = name
                    group.notify(queue: DispatchQueue.main) {
                        if result {
                            self.dismiss(animated: true, completion: nil)
                            self.performSegue(withIdentifier: Constants.Segues.recipeCetegorySegue, sender: self)
                        }
                    }
                }
            } else {
                //error
            }
        }
    }
    
    
    //MARK: - segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! RecipesViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            for i in viewModel.recipeCategories[indexPath.row].recipes! {
                vc.viewModel.recipes.append(i as! RecipeModel)
            }
            vc.viewModel.selectedCategory = viewModel.recipeCategories[indexPath.row]
        } else {
            let selectedCategory = viewModel.recipeCategories.first { (category) -> Bool in
                category.name == newCategoryName
            }
            
            guard let category = selectedCategory else { return }
            
            for i in category.recipes! {
                vc.viewModel.recipes.append(i as! RecipeModel)
            }
            vc.viewModel.selectedCategory = category
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
            viewModel.loadSavedData() {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        if searchBarText.count != 0 {
            viewModel.loadSavedData() {
                self.tableView.reloadData()
                if !self.viewModel.doesCategoryExist(for: searchBarText) {
                    self.performReqest(for: searchBarText)
                } else {
                    
                }
            }
        }
    }
}

