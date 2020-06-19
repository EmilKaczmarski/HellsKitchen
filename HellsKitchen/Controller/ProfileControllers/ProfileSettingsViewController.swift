//
//  ProfileSettingsViewController.swift
//  HellsKitchen
//
//  Created by Apple on 17/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class ProfileSettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var changeUsernameTextField: UITextField!
    @IBOutlet weak var changePasswordTextField: UITextField!
    @IBOutlet weak var profilePictureView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("", andImage: #imageLiteral(resourceName: "logo"))
        tabBarController?.tabBar.isHidden = false
        profilePictureView.layer.masksToBounds = true
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.width / 2
        buttonView.layer.cornerRadius = 25
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        loadProfilePicture()
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func changeProfilePictureButton(_ sender: Any) {
        profilePicturePicker()
        
    }
    
    @IBAction func removeAccountButtonPressed(_ sender: UIButton) {
        AlertManager.shared.confirmAccountRemovalAlert(in: self) { confirmed in
            if confirmed {
                FirebaseManager.shared.removeAccount { success in
                    if success {
                        AlertManager.shared.accountRemovedAlert(in: self) {
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - change profile picture
    
    func profilePicturePicker() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Profile Picture Source", message: "Choose a source", preferredStyle: .actionSheet)
        
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
            profilePicture.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePicture.image = originalImage
        }
        if let imageData = profilePicture.image?.jpegData(compressionQuality: 0.2) {
            FirebaseManager.shared.saveProfilePictureToFirebase(as: imageData)
        }
        FirebaseManager.shared.imageHasChanged()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func loadProfilePicture() {
        FirebaseManager.shared.getProfilePictureData(for: Constants.currentUserEmail) { (data, error) in
            if error != nil {
                self.profilePicture.image = Constants.currentUserProfilePicture
            } else {
                self.profilePicture.image = UIImage(data: data!)
                Constants.currentUserProfilePicture = UIImage(data: data!)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - change password/username
    
    //
    //      func enableSaveChangesButton() {
    //          saveChangesPasswordButton.isEnabled = true
    //      buttonView.backgroundColor =                Constants.Colors.deepGreen
    //      }
    //
    //      func disableSavehangesButton() {
    //          saveChangesButton.isEnabled = false
    //          buttonView.backgroundColor = Constants.Colors.deepGreenDisabled
    //      }
    
    
    @IBAction func saveChangesButton(_ sender: Any) {
        guard let username = changeUsernameTextField.text else { return }
        if username.contains(" ") || username.count == 0 || username.contains("@") {
            AlertManager.shared.wrongUsernameAlert(in: self)
            return
        }
        
        FirebaseManager.shared.checkWhetherUserExists(with: username) { (doesExist) in
            if doesExist {
                AlertManager.shared.notUniqueEmailAlert(in: self)
                return
            }
            FirebaseManager.shared.changeUsername(to: username) { (success) in
                if success {
                    AlertManager.shared.usernameChangedAlert(in: self)
                }
            }
        }
    }
}
