//
//  ProfileSettingsViewController.swift
//  HellsKitchen
//
//  Created by Apple on 17/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class ProfileSettingsViewController: UIViewController {
    
    @IBOutlet weak var changePasswordTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var changeUsernameTextField: UITextField!
    @IBOutlet weak var changeUsernameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("", andImage: #imageLiteral(resourceName: "logo"))
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func removeAccountButtonPressed(_ sender: UIButton) {
        AlertManager.shared.confirmAccountRemovalAlert(in: self) { confirmed in
            if confirmed {
                FirebaseManager.shared.removeAccount { success in
                    if success {
                        AlertManager.shared.accountRemovedAlert(in: self) {
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    //MARK: - change password/username
      
//      func enableChangePasswordButton() {
//          changePasswordButton.isEnabled = true
//      }
//
//      func disableChangePasswordButton() {
//          changePasswordButton.isEnabled = false
//      }
//
//      func enableChangeUsernameButton() {
//          changePasswordButton.isEnabled = true
//      }
//
//      func disableChangeUsernameButton() {
//          changePasswordButton.isEnabled = false
//      }

    
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
    }
    
    @IBAction func changeUsernameButtonPressed(_ sender: Any) {
        
        AlertManager.shared.askUserToChangeUsername(with: "please provide new username", in: self)
        
    }
    
    //      @IBAction func changePasswordTextFieldChanged(_ sender: Any) {
//          if !changePasswordTextField.text!.isEmpty {
//              enableChangePasswordButton()
//          } else {
//              disableChangePasswordButton()
//          }
//      }
//
//      @IBAction func changeUsernameTextFieldChanged(_ sender: Any) {
//          if !changeUsernameTextField.text!.isEmpty && !changeUsernameTextField.text!.contains(" ") {
//              enableChangeUsernameButton()
//          } else {
//              disableChangeUsernameButton()
//          }
//      }
}
