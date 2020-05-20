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
    
    let viewModel: RegisterViewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        registerView.layer.cornerRadius = 10
        navigationController?.navigationBar.tintColor = UIColor(hexaString: Constants.Colors.deepRed)
        registerButton.layer.cornerRadius = 10
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
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let nickname = usernameTextField.text else { return }
        viewModel.registerUser(nickname, emailTextField: emailTextField.text, passwordTextField: passwordTextField.text)
    }
    
}
