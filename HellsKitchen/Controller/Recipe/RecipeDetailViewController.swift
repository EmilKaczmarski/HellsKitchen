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

    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    let viewModel: RecipeDetailViewModel = RecipeDetailViewModel()
    var isImageViewFocused = false
    var imageScale = 1.0
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var url: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("hell's kitchen", andImage: #imageLiteral(resourceName: "fire"))
        radiusView.layer.cornerRadius = 26
        radiusView.layer.masksToBounds = true
        radiusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.delegate = self
        tableView.register(IngredientCell.self, forCellReuseIdentifier: "cell")
        
        viewModel.setupData()
        uploadImage()
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        viewModel.delegate = self
    }
    
    func uploadImage() {
        if let imageData = viewModel.recipe!.image {
            imageView.image = UIImage(data: imageData)
        } else {
            downloadImage()
        }
    }

    func downloadImage() {
        AF
            .request(viewModel.recipe!.imageUrl ?? "", method:  .get)
            .response {
                response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        //self.stopAnimatingView()
                        self.imageView.image = UIImage(data: data!)
                        self.viewModel.saveImage(data: data!)

                    }
                case .failure(let error):
                    print(error)
                    //self.stopAnimatingView()
                }
        }
    }

//    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
//        isImageViewFocused = !isImageViewFocused
//        if isImageViewFocused {
//            infoStackView.isHidden = true
//            ingredientsStackView.isHidden = true
//        } else {
//            infoStackView.isHidden = false
//            ingredientsStackView.isHidden = false
//        }
//    }
//
//    @IBAction func handlePinch(_ sender: UIPinchGestureRecognizer) {
//        guard let gestureView = sender.view else { return }
//        guard isImageViewFocused == true else { return }
//
//        gestureView.transform = gestureView.transform.scaledBy(
//            x: sender.scale,
//            y: sender.scale
//        )
//        imageScale *= Double(sender.scale)
//        guard sender.state == .ended else { return }
//        gestureView.transform = gestureView.transform.scaledBy(
//            x: CGFloat(1/imageScale),
//            y: CGFloat(1/imageScale)
//               )
//        imageScale = 1
//    }


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
