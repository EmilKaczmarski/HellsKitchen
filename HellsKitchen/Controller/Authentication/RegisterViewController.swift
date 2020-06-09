//
//  RegisterViewController.swift
//  HellsKitchen
//
//  Created by Apple on 12/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerLoader: UIActivityIndicatorView!
    
    let viewModel: RegisterViewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupRegisterButton()
        setTitle("hell's kitchen", andImage: #imageLiteral(resourceName: "fire"))
        registerView.layer.cornerRadius = 20
        FirebaseManager.shared.registerViewController = self
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
    func enableRegisterButton() {
        registerButton.isEnabled = true
        registerView.backgroundColor = Constants.Colors.deepGreen
    }
    
    func disableRegisterButton() {
        registerButton.isEnabled = false
        registerView.backgroundColor = Constants.Colors.deepGreenDisabled
    }
    
    
    @IBAction func usernameTextChanged(_ sender: Any) {
        if emailTextField.text!.contains("@") && !passwordTextField.text!.isEmpty && !usernameTextField.text!.isEmpty {
            enableRegisterButton()
        } else {
            disableRegisterButton()
        }
    }
    
    @IBAction func emailTextChanged(_ sender: Any) {
        if emailTextField.text!.contains("@") && !passwordTextField.text!.isEmpty && !usernameTextField.text!.isEmpty {
            enableRegisterButton()
        } else {
            disableRegisterButton()
        }
    }
    
    @IBAction func passwordTextChanged(_ sender: Any) {
        if emailTextField.text!.contains("@") && !passwordTextField.text!.isEmpty && !usernameTextField.text!.isEmpty {
            enableRegisterButton()
        } else {
            disableRegisterButton()
        }
    }
    
    func setupRegisterButton() {
        disableRegisterButton()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        self.registerLoader.startAnimating()
        guard let nickname = usernameTextField.text else { return }
        viewModel.registerUser(nickname, emailTextField: emailTextField.text, passwordTextField: passwordTextField.text)
        self.registerLoader.stopAnimating()
    }
    
}
