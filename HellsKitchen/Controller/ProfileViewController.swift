//
//  ProfileViewController.swift
//  HellsKitchen
//
//  Created by Aleksandra Brzostek on 5/30/20.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var logOutIcon: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.cornerRadius = profilePicture.bounds.width / 2
        setTitle("hell's kitchen", andImage: #imageLiteral(resourceName: "fire"))
        tabBarController?.tabBar.isHidden = false
        username.text = Constants.currentUserName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        username.text = Constants.currentUserName
        loadProfilePicture()
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        profilePicturePicker()
    }
    
    @IBAction func notificationsButtonPressed(_ sender: Any) {
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        LoginManager().logOut()
        FirebaseManager.shared.signOutUser { success in
            if success {
                
            }
        }
    }
    
    func loadProfilePicture() {
        FirebaseManager.shared.getProfilePictureData(for: Constants.currentUserName) { (data, error) in
            if error != nil {
                self.profilePicture.image = Constants.Pictures.defaultProfile
            } else {
                self.profilePicture.image = UIImage(data: data!)
            }
            self.view.layoutIfNeeded()
        }
    }
    
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
            FirebaseManager.shared.saveImageToFirebase(as: imageData)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
