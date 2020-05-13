//
//  LoginViewController.swift
//  HellsKitchen
//
//  Created by Apple on 12/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    if let user = Auth.auth().currentUser {
                        if user.isEmailVerified {
                            print("email verified")
                        } else {
                            print("no verified email")
                        }
                        
                    }
                    self.performSegue(withIdentifier: Constants.Segues.loginSegue, sender: self)
                }
            }
        }
    }
    
}
