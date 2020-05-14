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
    
    let viewModel: RegisterViewModel = RegisterViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let nickname = usernameTextField.text else { return }
        viewModel.registerUser(nickname, emailTextField: emailTextField.text, passwordTextField: passwordTextField.text)
    }
    
}
