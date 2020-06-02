//
//  CreatePostViewController.swift
//  HellsKitchen
//
//  Created by Apple on 14/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var header: UITextField!
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var uploadedImage: UIImageView!
    
    
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
    
    
    @IBAction func addPhotoButtonPressed(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                          self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
          
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        //let image = info[UIImagePickerController.InfoKey] as? UIImage
        //uploadedImage.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
