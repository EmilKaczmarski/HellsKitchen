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
    @IBOutlet weak var calories: UILabel!
    
    @IBOutlet weak var cooking: UILabel!
    let viewModel: PostDetailViewModel = PostDetailViewModel()
    
    var postId: String?
    var post: Post?
    var postImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("", andImage: #imageLiteral(resourceName: "logo"))
        radiusView.layer.cornerRadius = 26
        radiusView.layer.masksToBounds = true
        radiusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        image.image = postImage
        owner.text = post?.owner
        if let stamp = post?.createTimestamp {
            let createTimestamp = Double(stamp)
            date.text = TimeDisplayManager.shared.getDateForPostCell(timestamp: createTimestamp!)
        }
        header.text = post?.title
        content.text = post?.content
        cooking.text = post?.cooking
        calories.text = post?.calories
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        //viewModel.delegate = self
    }
}
