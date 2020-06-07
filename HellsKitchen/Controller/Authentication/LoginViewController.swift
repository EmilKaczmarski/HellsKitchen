//
//  LoginViewController.swift
//  HellsKitchen
//
//  Created by Apple on 12/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, LoginButtonDelegate {
    @IBOutlet weak var loginButtonView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLoader: UIActivityIndicatorView!
    let viewModel: LoginViewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginButton()
        viewModel.delegate = self
        //Facebook
//        FBLoginButton.delegate = self
//        FBLoginButton.permissions = ["public_profile", "email"]
        //Google
//        GIDSignIn.sharedInstance()?.presentingViewController = self
        //FirebaseManager.shared.loginViewController = self
        //GIDSignIn.sharedInstance().signIn()
        setTitle("hell's kitchen", andImage: #imageLiteral(resourceName: "fire"))
        loginButtonView.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        setupBackButtonTitle()
    }
    
    func setupBackButtonTitle() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            loginLoader.startAnimating()
            FirebaseManager.shared.signIn(email: email, password: password, in: self) {
                self.navigationController?.popToRootViewController(animated: false)
                //self.tabBarController?.selectedIndex = 4
            
                self.loginLoader.stopAnimating()
            }
        }
    }
    
    @IBAction func emailTextChanged(_ sender: Any) {
        if emailTextField.text!.contains("@") && !passwordTextField.text!.isEmpty {
            enableLoginButton()
        }
        else {
            disableLoginButton()
        }
    }

    @IBAction func passwordTextChanged(_ sender: Any) {
        if !passwordTextField.text!.isEmpty && emailTextField.text!.contains("@"){
            enableLoginButton()
        }
        else {
            disableLoginButton()
        }
    }
    
    func setupLoginButton() {
        disableLoginButton()
    }
    
    func enableLoginButton() {
        loginButton.isEnabled = true
        loginButtonView.backgroundColor = Constants.Colors.deepGreen
    }
    
    func disableLoginButton() {
        loginButton.isEnabled = false
        loginButtonView.backgroundColor = Constants.Colors.deepGreenDisabled
    }
    
    @IBAction func registerNowButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.registerSegue, sender: self)
    }
    
    
//MARK: - facebook extension
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("did logout from facebook")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        FirebaseManager.shared.signInWithExternalApplication(with: credential, type: .login) {
        
        }
    }
}
