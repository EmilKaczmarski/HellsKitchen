//
//  AlertManager.swift
//  HellsKitchen
//
//  Created by Apple on 24/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class AlertManager {
    static let shared = AlertManager()
    private init() { }
    
    func textInputAlert(with windowTitle: String, buttonTitle: String, for controller: UIViewController) {
        let alert = UIAlertController(title: windowTitle, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: {
            action in
            // Called when user taps outside
        }))
        controller.present(alert, animated: true)
    }
    
    func askNewUserToProvideName(with title: String, in controller: UIViewController) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "new username"
        }
        alert.addAction(UIAlertAction(title: "done", style: .cancel, handler: {
            action in
            guard let username = alert.textFields![0].text else { return }
            
            FirebaseManager.shared.checkWhetherUserExists(with: username) { (doesExist) in
                if doesExist {
                    AlertManager.shared.askNewUserToProvideName(with: "whoops username is not unique, please provide new one", in: controller)
                } else {
                    let userEmail = FirebaseManager.shared.getCurrentUser()
                    Constants.currentUserEmail = userEmail
                    FirebaseManager.shared.setCurrentUsername {
                        controller.navigationController?.popToRootViewController(animated: true)
                        FirebaseManager.shared.addUserToList(email: userEmail, username: username)
                    }
                }
            }
        }))
        controller.present(alert, animated: false)
    }
}
