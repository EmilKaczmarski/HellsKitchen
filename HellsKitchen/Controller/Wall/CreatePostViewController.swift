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
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var nameLine: UIView!
    @IBOutlet weak var contentLine: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var addRecipeButton: UIButton!
    @IBOutlet weak var editingView: UIView!
    
    let viewModel: PostDetailViewModel = PostDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupAddRecipeButton()
        setTitle("hell's kitchen", andImage: #imageLiteral(resourceName: "fire"))
        buttonView.layer.cornerRadius = 20
        uploadedImage.layer.masksToBounds = true
        uploadedImage.contentMode = .scaleToFill
        uploadedImage.layer.borderWidth = 1
        uploadedImage.layer.borderColor = Constants.Colors.deepGreen.cgColor
        hideStackViewOrEditingView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        hideStackViewOrEditingView()
        setupCancelButtonTitle()

    }
    
    func setupCancelButtonTitle() {
        let cancelButton = UIBarButtonItem()
        cancelButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = cancelButton
    }
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        tabBarController?.selectedIndex = 0
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
  
    
    @IBAction func nameTextChanged(_ sender: Any) {
        
    if !header.text!.isEmpty && uploadedImage.image != nil {
        enableAddRecipeButton()
        nameLine.backgroundColor = Constants.Colors.deepGreen
        } else {
            disableAddRecipeButton()
        }
    }
    
    func setupAddRecipeButton() {
        disableAddRecipeButton()
    }
    
    func enableAddRecipeButton() {
         addRecipeButton.isEnabled = true
         buttonView.backgroundColor = Constants.Colors.deepGreen
    }
     
    func disableAddRecipeButton() {
         addRecipeButton.isEnabled = false
         buttonView.backgroundColor = Constants.Colors.deepGreenDisabled
    }
    
    //MARK: - Adding photo
    
    func photoPicker() {

    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    
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
       
           if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
               uploadedImage.image = editedImage
             } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               uploadedImage.image = originalImage
               
           }
           dismiss(animated: true, completion: nil)
    }
       
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
            hideStackViewOrEditingView()
    }
       
    
    @IBAction func addPhotoButtonPressed(_ sender: Any) {
        photoPicker()
        hideStackViewOrEditingView()
    }
    
   
    @IBAction func editingButtonPressed(_ sender: Any) {
        photoPicker()
        hideStackViewOrEditingView()
    }
    
}

//MARK: - extensions

/*extension CreatePostViewController: UIImage {
    func resize(_ width: CGFloat, _ height:CGFloat) -> UIImage? {
        let widthRatio  = width / size.width
        let heightRatio = height / size.height
        let ratio = widthRatio > heightRatio ? heightRatio : widthRatio
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
*/
extension CreatePostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        bottomView.sizeToFit()
        placeholderLabel.isHidden = !textView.text.isEmpty
        contentLine.backgroundColor = Constants.Colors.deepGreen
    }
}

extension CreatePostViewController {
    func hideStackViewOrEditingView() {
           if uploadedImage.image != nil {
               infoStackView.isHidden = true
               editingView.isHidden = false
           } else {
             infoStackView.isHidden = false
             editingView.isHidden = true
        }
    }
}
