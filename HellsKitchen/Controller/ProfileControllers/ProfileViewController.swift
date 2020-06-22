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
        setTitle("", andImage: #imageLiteral(resourceName: "logo"))
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
        
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        LoginManager().logOut()
        FirebaseManager.shared.signOutUser { success in
            if success {
                self.navigationController?.popViewController(animated: false)
            }
        }
         Constants.currentUserProfilePicture = UIImage(named: "defaultProfilePicture")
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
    
    
}
