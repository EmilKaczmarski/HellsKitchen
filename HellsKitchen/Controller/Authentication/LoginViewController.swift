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
        navigationController?.navigationBar.tintColor = UIColor(hexaString: Constants.Colors.deepRed)
        loginButton.isEnabled = false
        loginButton.setTitleColor(UIColor(hexaString: Constants.Colors.lightGreen), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupBackButtonTitle()
    }
    
    func setupBackButtonTitle() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            viewModel.signIn(email: email, password: password)
        }
    }
    
    //checking if email contains @
    @IBAction func emailTextChanged(_ sender: Any) {
        if emailTextField.text!.contains("@") && !passwordTextField.text!.isEmpty {
            enableLoginButton()
        }
        else {
            disableLoginButton()
        }
        
    }
    
    func enableLoginButton() {
        loginButton.isEnabled = true
        loginButton.setTitleColor(UIColor(hexaString: Constants.Colors.deepRed), for: .normal)
    }
    
    func disableLoginButton() {
        loginButton.isEnabled = false
        loginButton.setTitleColor(UIColor(hexaString: Constants.Colors.lightGreen), for: .normal)
    }
    //checking if password has at least 1 char
    @IBAction func passwordTextChanged(_ sender: Any) {
        
        if !passwordTextField.text!.isEmpty && emailTextField.text!.contains("@"){
            enableLoginButton()
        }
        else {
            disableLoginButton()
        }
    }
    
    @IBAction func registerNowButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.registerSegue, sender: self)
    }
}
