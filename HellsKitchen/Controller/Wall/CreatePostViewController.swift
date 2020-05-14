//
//  CreatePostViewController.swift
//  HellsKitchen
//
//  Created by Apple on 14/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var header: UITextField!
    @IBOutlet weak var content: UITextField!
    
    let viewModel: PostDetailViewModel = PostDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        if header.text! != "" && content.text! != "" {
            let timestamp = "\(Date().timeIntervalSince1970)"
            let post = Post(id: "\(Constants.currentUserName)\(Int(timestamp))", title: header.text!, owner: Constants.currentUserName, content: content.text!, createTimestamp: timestamp, lastCommentTimestamp: timestamp, comments: [])
            header.text! = ""
            content.text! = ""
            viewModel.savePost(post)
            navigationController?.popViewController(animated: true)
        }
    }
}
