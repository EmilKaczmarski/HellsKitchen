//
//  SignInMenuViewController.swift
//  HellsKitchen
//
//  Created by Apple on 01/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class SignInMenuViewController: UIViewController, GIDSignInDelegate {
    
    var lowerTitle = ""
    var upperTitle = ""
    @IBOutlet weak var FBLoginButton: UIButton!
    @IBOutlet weak var lowerLabel: UILabel!
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var signWithGoogleView: UIView!
    @IBOutlet weak var signWithFacebookView: UIView!
    @IBOutlet weak var signWithEmailView: UIView!
    @IBOutlet weak var loginLoader: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseManager.shared.signInViewController = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        setTitle("hell's kitchen", andImage: #imageLiteral(resourceName: "fire"))
        GIDSignIn.sharedInstance().delegate = self
        setupLoginButtonsViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        setupUpperAndLowerTitle()
        if Constants.currentUserName != "" {
            navigationController?.popToRootViewController(animated: false)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
    }
    
    func setupUpperAndLowerTitle() {
        upperLabel.text = upperTitle
        lowerLabel.text = lowerTitle
    }
    
    func setupLoginButtonsViews() {
        signWithGoogleView.layer.borderWidth = 1
        signWithFacebookView.layer.borderWidth = 1
        signWithEmailView.layer.borderWidth = 1
        
        signWithGoogleView.layer.borderColor = Constants.Colors.deepGreen.cgColor
        signWithFacebookView.layer.borderColor = Constants.Colors.deepGreen.cgColor
        signWithEmailView.layer.borderColor = Constants.Colors.deepGreen.cgColor
        
        signWithGoogleView.layer.cornerRadius = 25
        signWithFacebookView.layer.cornerRadius = 25
        signWithEmailView.layer.cornerRadius = 25
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func googleLoginPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func FBLogginButtonPressed(_ sender: UIButton) {
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let token = AccessToken.current {
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                
                GraphRequest(graphPath: "/me", parameters: ["fields": "email"]).start { (connection, result, err) in
                    if error != nil {
                        print("Error",error!.localizedDescription)
                    } else {
                        let field = result! as? [String:Any]
                        let userId = field!["id"]
                        let imageURL = "http://graph.facebook.com/\(userId!)/picture?type=large"
                        print(imageURL)
                        let url = URL(string: imageURL)
                        if let data = NSData(contentsOf: url!) {
                            let image = UIImage(data: data as Data)
                            Constants.externalRegisterProfilePicture = image
                        }
                    }
                }
                if !token.isExpired {
                    FirebaseManager.shared.signInWithExternalApplication(with: credential, type: .login) {
                        self.loginLoader.stopAnimating()
                        
                        guard let hasDefaultImage = Constants.hasDefaultImage else { return }
                        if hasDefaultImage {
                            Constants.currentUserProfilePicture = Constants.externalRegisterProfilePicture!
                        }
                        FirebaseManager.shared.saveProfilePictureToFirebase(as: (Constants.currentUserProfilePicture?.jpegData(compressionQuality: 0.2))!)
                    }
                }
            }
        }
    }
    
    //MARK: - google signin functions
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        if user.profile.hasImage {
            let pic = user.profile.imageURL(withDimension: 100)
            let url = URL(string: pic!.absoluteString)
            print(pic?.absoluteString)
            if let data = NSData(contentsOf: url!) {
                let image = UIImage(data: data as Data)
                Constants.externalRegisterProfilePicture = image
            }
        }
        FirebaseManager.shared.signInWithExternalApplication(with: credential, type: .login) {
            self.loginLoader.stopAnimating()
            guard let hasDefaultImage = Constants.hasDefaultImage else { return }
            if hasDefaultImage {
                if user.profile.hasImage
                {
                    let pic = user.profile.imageURL(withDimension: 100)
                    let url = URL(string: pic!.absoluteString)
                    print(pic?.absoluteString)
                    if let data = NSData(contentsOf: url!) {
                        let image = UIImage(data: data as Data)
                        Constants.currentUserProfilePicture = image
                    }
                }
                FirebaseManager.shared.saveProfilePictureToFirebase(as: (Constants.currentUserProfilePicture?.jpegData(compressionQuality: 0.2))!)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
