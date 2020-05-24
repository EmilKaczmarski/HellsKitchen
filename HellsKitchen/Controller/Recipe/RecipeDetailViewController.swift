//
//  RecipeDetailViewController.swift
//  HellsKitchen
//
//  Created by Apple on 24/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import Alamofire

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    let viewModel: RecipeDetailViewModel = RecipeDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(IngredientCell.self, forCellReuseIdentifier: "cell")
        viewModel.delegate = self
        viewModel.setupData()
        startAnimatingView()
        downloadImage()
    }
    
    func startAnimatingView() {
        
        loadingIndicator.startAnimating()
        loaderView.frame.size.height = imageView.frame.size.height
        imageView.isHidden = true
        loaderView.isHidden = false
    }
    
    func stopAnimatingView() {
        loadingIndicator.stopAnimating()
        imageView.frame.size.height = loaderView.frame.size.height
        loaderView.isHidden = true
        imageView.isHidden = false
    }
    
    func downloadImage() {
        AF
            .request(viewModel.recipe!.image ?? "", method:  .get)
            .response {
                response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.stopAnimatingView()
                        self.imageView.image = UIImage(data: data!)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
}

extension RecipeDetailViewController: UITableViewDelegate {
    
}

extension RecipeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IngredientCell
        cell.name.text = viewModel.ingredients[indexPath.row].name
        cell.weight.text = "\(viewModel.ingredients[indexPath.row].weight)"
        return cell
    }
    

}
