//
//  RecipesTableViewController.swift
//  HellsKitchen
//
//  Created by Aleksandra Brzostek on 5/16/20.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import SwipeCellKit

class RecipeCategoryViewController: UIViewController, SwipeTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var noPostsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var newCategoryName = ""
    //how to get only one value from struct?
    let viewModel: RecipeCategoryViewModel = RecipeCategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupTableView()
        viewModel.loadSavedData() {
            self.tableView.reloadData()
        }
        setTitle("hell's kitchen", andImage: #imageLiteral(resourceName: "fire"))
        setupSearchBar()
        showNoPostViewIfNeeded()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50.0
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupSearchBar() {
        searchBarView.layer.cornerRadius = 25
        searchBarView.layer.borderWidth = 1
        searchBarView.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.searchTextField.backgroundColor = .white
    }
    
    //MARK: - tableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipeCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.selectionStyle = .none
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
        showNoPostViewIfNeeded()
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
                self.showNoPostViewIfNeeded()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        if searchBarText.count != 0 {
            viewModel.loadSavedData() {
                self.tableView.reloadData()
                self.showNoPostViewIfNeeded()
                if !self.viewModel.doesCategoryExist(for: searchBarText) {
                    self.performReqest(for: searchBarText)
                } else {
                    
                }
            }
        }
    }
}

//MARK: - search bar methods
extension RecipeCategoryViewController {
    func showNoPostViewIfNeeded() {
        if viewModel.recipeCategories.count == 0 {
            noPostsView.isHidden = false
        } else {
            noPostsView.isHidden = true
        }
    }
}
