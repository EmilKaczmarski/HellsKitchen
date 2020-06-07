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
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            FirebaseManager.shared.signInWithExternalApplication(with: credential, type: .login) {
                self.loginLoader.stopAnimating()
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
        
        FirebaseManager.shared.signInWithExternalApplication(with: credential, type: .login) {
            self.loginLoader.stopAnimating()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
