//
//  RegisterViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//
import Foundation
import Firebase

class RegisterViewModel {
    var delegate: RegisterViewController?
    let db = Firestore.firestore()
    
    func registerUser(_ nickname: String, emailTextField: String?, passwordTextField: String?) {
        
        if nickname.contains(" ") || nickname.count == 0 || nickname.contains("@") {
            print("alert here!!!!")
            return
        }
        
        FirebaseManager.shared.checkWhetherUserExists(with: nickname) {[weak self] (doesExist) in
            if !doesExist {
                if let email = emailTextField, let password = passwordTextField {
                    FirebaseManager.shared.createUser(email: email, password: password, username: nickname)
//                    Constants.currentUserName = nickname
//                    Constants.currentUserEmail = email
                    //need to verify email alert
                    self!.delegate!.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
}
