//
//  LoginViewController.swift
//  HellsKitchen
//
//  Created by Apple on 12/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let viewModel: LoginViewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        loginButton.isEnabled = false
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            viewModel.signIn(email: email, password: password)
        }
    }
    
    //checking if email contains @
    //is loop necessary?
    @IBAction func emailTextChanged(_ sender: Any) {
        if emailTextField.text!.contains("@") {
            loginButton.isEnabled = true
        }
        else {
            loginButton.isEnabled = false
        }
        
    }
    
    //checking if password has at least 1 char
    @IBAction func passwordTextChanged(_ sender: Any) {
        
        if passwordTextField.text!.isEmpty {
            loginButton.isEnabled = false
        }
        else {
            loginButton.isEnabled = true
        }
    }
    
    @IBAction func registerNowButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "registerViewSegue", sender: self)
    }
    
    
}
