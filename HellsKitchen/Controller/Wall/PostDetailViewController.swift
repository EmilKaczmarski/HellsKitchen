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
    
    
    @IBOutlet weak var allPostView: UIView!
    @IBOutlet weak var allPostStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var calories: UILabel!
    
    @IBOutlet weak var cooking: UILabel!
    var recipes = [UILabel]()
    
    let viewModel: CreatePostViewModel = CreatePostViewModel()
    
    var postId: String?
    var post: Post?
    var postImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("", andImage: #imageLiteral(resourceName: "logo"))
        allPostView.layer.cornerRadius = 26
        allPostView.layer.masksToBounds = true
        allPostView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        image.image = postImage
        owner.text = post?.ownerName
        if let stamp = post?.createTimestamp {
            let createTimestamp = Double(stamp)
            date.text = TimeDisplayManager.shared.getDateForPostCell(timestamp: createTimestamp!)
        }
        header.text = post?.title
        content.text = post?.content
        cooking.text = post?.cooking
        calories.text = post?.calories
        insertNeededRecipes()
        refreshView()
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        //viewModel.delegate = self
    }
    
    func insertNeededRecipes() {
        guard let ingredients = post?.ingredients else { return }
        for i in ingredients {
            let label = UILabel()
            label.text = i
            label.textColor = Constants.Colors.deepGreen
            label.font = UIFont.systemFont(ofSize: 14.0)
            allPostStackView.insertArrangedSubview(label, at: 3)
            recipes.append(label)
        }
    }
    
    func refreshView() {
        allPostStackView.sizeToFit()
        allPostStackView.layoutIfNeeded()
        allPostView.sizeToFit()
        allPostView.layoutIfNeeded()
    }
}
