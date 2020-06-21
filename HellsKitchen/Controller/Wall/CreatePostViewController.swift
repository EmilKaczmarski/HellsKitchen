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
    
    @IBOutlet weak var wholePostStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullPostAndButtonStackView: UIStackView!
    @IBOutlet weak var ingredientsStackView: UIStackView!
    @IBOutlet weak var addIngredientView: UIView!
    
    var fields = [IngredientInputView]()
    
    let viewModel = CreatePostViewModel()
    let postDetailviewModel: PostDetailViewModel = PostDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        postDetailviewModel.delegate = self
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
        
        addIngredientView.layer.cornerRadius = 20
        addIngredientView.layer.borderWidth = 1
        addIngredientView.layer.borderColor = Constants.Colors.deepGreen.cgColor
        IngredientInputView.delegate = self
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
        
        if thereAreEmptyFields() {
            AlertManager.shared.actionSuccessfullyCompleted(with: "Please make sure that there are no recipes with empty fields", in: self)
            return
        }
        
        if header.text! != "" && content.text! != "" && calories.text! != "" && cooking.text! != "" {
            let timestamp = "\(Int(Date().timeIntervalSince1970))"
            let post = Post(id: "\(Constants.currentUserEmail)\(timestamp)", title: header.text!, ownerName: Constants.currentUserName, ownerEmail: Constants.currentUserEmail, content: content.text!, cooking: cooking.text!, calories: calories.text!, createTimestamp: timestamp, ingredients: fields.map { $0.field.text! } )
            
            header.text! = ""
            content.text! = ""
            cooking.text! = ""
            calories.text! = ""
            postDetailviewModel.savePost(post)
            FirebaseManager.shared.savePostPictureToFirebase(as: (uploadedImage.image?.jpegData(compressionQuality: 0.4))!, for: post.id)
            removeAllIngredientsFromView()
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
            kcalLabel.isHidden = false
        } else {
            caloriesLine.backgroundColor = Constants.Colors.lightGray
            kcalLabel.isHidden = true
        }
    }
    
    func removeAllIngredientsFromView() {
        for i in fields {
            i.removeFromSuperview()
        }
        for i in 0..<fields.count {
            fields.remove(at: 0)
        }
    }
    
    func thereAreEmptyFields()-> Bool {
        for i in fields {
            if i.field.text?.count == 0 {
                return true
            }
            let spaceCount = i.field.text?.reduce(0) { $1.isWhitespace && !$1.isNewline ? $0 + 1 : $0 }
            if spaceCount == i.field.text?.count {
                return true
            }
        }
        return false
    }
    
    func addRecipteButtonSwitch() {
        if !header.text!.isEmpty && uploadedImage.image != nil {
            if !cooking.text!.isEmpty && !calories.text!.isEmpty && fields.count > 0{
              enableAddRecipeButton()
            } else {
                disableAddRecipeButton()
            }
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
    
    @IBAction func addIngredientButtonPressed(_ sender: UIButton) {
        let ingredientView = IngredientInputView()
        fullPostAndButtonStackView.insertArrangedSubview(ingredientView, at: fields.count + 2)
        ingredientView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().offset(-20)
            maker.height.equalTo(40)
        }
        ingredientView.field.tag = fields.count + 2
        ingredientView.deleteButton.tag = fields.count + 2
        ingredientView.deleteButton.addTarget(IngredientInputView.delegate!, action: #selector(removeField), for: .touchUpInside)
        fullPostAndButtonStackView.sizeToFit()
        fullPostAndButtonStackView.layoutIfNeeded()
        fields.append(ingredientView)
    }
    
    @objc func removeField(_ sender: UIButton) {
        let tag = sender.tag
        let fieldToRemove = fields.first { (view) -> Bool in
            return view.deleteButton.tag == tag
        }
        guard let field = fieldToRemove else { return }
        let firstIndex = fields.firstIndex(of: field)
        fields.remove(at: firstIndex!)
        field.removeFromSuperview()
        fullPostAndButtonStackView.layoutIfNeeded()
        fullPostAndButtonStackView.sizeToFit()
        for i in fields {
            if i.deleteButton.tag > tag {
                i.deleteButton.tag -= 1
                i.field.tag -= 1
            }
        }
    }
}

//MARK: - extensions
extension CreatePostViewController: UITextFieldDelegate {
    
}

extension CreatePostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        contentView.layoutIfNeeded()
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

//MARK: - scrollview delegate
extension CreatePostViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
