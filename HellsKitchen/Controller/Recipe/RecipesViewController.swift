//
//  Recipes.swift
//  HellsKitchen
//
//  Created by Apple on 22/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var separatorView: UIView!
    let viewModel: RecipesViewModel = RecipesViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 54

        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: "cell")
        viewModel.delegate = self
        setupSearchBar()
        setTitle("hell's kitchen", andImage: #imageLiteral(resourceName: "fire"))
        loadImages()
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

}

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }

       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecipeTableViewCell
        cell.name.text = viewModel.recipes[indexPath.row].label
        if let data = viewModel.recipes[indexPath.row].image {
            cell.imageBox.image = UIImage(data: data)
        }
        cell.selectionStyle = .none
        return cell
    }
    
}

//MARK: - loading images
extension RecipesViewController {
    func loadImages() {
        for recipe in viewModel.recipes {
            if recipe.image == nil {
                viewModel.downloadImage(for: recipe) {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
//MARK: - search bar
extension RecipesViewController {
    func setupSearchBar() {
        searchBarView.layer.cornerRadius = 25
        searchBarView.layer.borderWidth = 1
        searchBarView.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.searchTextField.backgroundColor = .white
    }
}


//MARK: - segue methods
extension RecipesViewController {
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

//MARK: - searchBar methods
extension RecipesViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        
        if searchBarText.count != 0 {
            viewModel.loadDataThatContains(text: searchBarText)
        } else {
            viewModel.loadSavedData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchBarText = searchBar.text else { return }

        if searchBarText.count != 0 {
            viewModel.loadDataThatContains(text: searchBarText)
        } else {
            viewModel.loadSavedData()
        }
    }
}
