//
//  PostDetailViewController.swift
//  HellsKitchen
//
//  Created by Apple on 14/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var radiusView: UIView!
    
    let viewModel: PostDetailViewModel = PostDetailViewModel()
    
    var postId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("hell's kitchen", andImage: #imageLiteral(resourceName: "fire"))
        radiusView.layer.cornerRadius = 26
        radiusView.layer.masksToBounds = true
        radiusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //viewModel.delegate = self
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        //viewModel.delegate = self
    }
}
