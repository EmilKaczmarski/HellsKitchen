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
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var nameLine: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var addRecipeButton: UIButton!
    @IBOutlet weak var editingView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var contentPlaceholder: UILabel!
    @IBOutlet weak var caloriesLine: UIView!
    @IBOutlet weak var kcalLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var cookingTimeLine: UIView!
    @IBOutlet weak var cooking: UITextField!
    @IBOutlet weak var calories: UITextField!
    
    let viewModel: PostDetailViewModel = PostDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupAddRecipeButton()
        setTitle("", andImage: #imageLiteral(resourceName: "logo"))
        minutesLabel.isHidden = true
        kcalLabel.isHidden = true
        buttonView.layer.cornerRadius = 20
        uploadedImage.layer.masksToBounds = true
        uploadedImage.contentMode = .scaleToFill
        uploadedImage.layer.borderWidth = 1
        uploadedImage.layer.borderColor = Constants.Colors.deepGreen.cgColor
        hideStackViewOrEditingView()
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = Constants.Colors.lightGray.cgColor
        content.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        uploadedImage.image = nil
        hideStackViewOrEditingView()
        setupCancelButtonTitle()
        header.text = ""
        content.text = ""
        cooking.text = ""
        calories.text = ""
        if Constants.currentUserName != "" {
            navigationController?.popToRootViewController(animated: false)
        }
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
        if header.text! != "" && content.text! != "" && calories.text! != "" && cooking.text! != "" {
            let timestamp = "\(Int(Date().timeIntervalSince1970))"
            let post = Post(id: "\(Constants.currentUserName)\(timestamp)", title: header.text!, owner: Constants.currentUserName, content: content.text!, cooking: cooking.text!, calories: calories.text!, createTimestamp: timestamp)
            header.text! = ""
            content.text! = ""
            cooking.text! = ""
            calories.text! = ""
            viewModel.savePost(post)
            FirebaseManager.shared.savePostPictureToFirebase(as: (uploadedImage.image?.jpegData(compressionQuality: 0.4))!, for: post.id)
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    
    @IBAction func nameTextChanged(_ sender: Any) {
        if !header.text!.isEmpty {
            nameLine.backgroundColor = Constants.Colors.deepGreen
        } else {
            nameLine.backgroundColor = Constants.Colors.lightGray
        }
        
        addRecipteButtonSwitch()
    }
    
    
    @IBAction func cookingTextChanged(_ sender: Any) {
        if !cooking.text!.isEmpty {
            cookingTimeLine.backgroundColor = Constants.Colors.deepGreen
            minutesLabel.isHidden = false
        } else {
            cookingTimeLine.backgroundColor = Constants.Colors.lightGray
            minutesLabel.isHidden = true
        }
    }
    
    @IBAction func caloriesTextChanged(_ sender: Any) {
        if !calories.text!.isEmpty {
            caloriesLine.backgroundColor = Constants.Colors.deepGreen
            minutesLabel.isHidden = false
        } else {
            caloriesLine.backgroundColor = Constants.Colors.lightGray
            minutesLabel.isHidden = true
        }
    }
    func addRecipteButtonSwitch() {
        if !header.text!.isEmpty && uploadedImage.image != nil && !cooking.text!.isEmpty && !calories.text!.isEmpty {
            enableAddRecipeButton()
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
        hideStackViewOrEditingView()
        addRecipteButtonSwitch()
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

extension CreatePostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        contentView.sizeToFit()
        contentPlaceholder.isHidden = !textView.text.isEmpty
        
        if !content.text!.isEmpty {
            contentView.layer.borderColor = Constants.Colors.deepGreen.cgColor
        } else {
            contentView.layer.borderColor = Constants.Colors.lightGray.cgColor
        }
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
