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
    
    func registerUser(_ nickname: String, emailTextField: String?, passwordTextField: String?, completion: @escaping (Bool)-> ()) {
        
        if nickname.contains(" ") || nickname.count == 0 || nickname.contains("@") {
            AlertManager.shared.wrongUsernameAlert(in: delegate!)
            completion(false)
            return
        }
        
        FirebaseManager.shared.checkWhetherUserExists(with: nickname) { (doesExist) in
            if !doesExist {
                if let email = emailTextField, let password = passwordTextField {
                    FirebaseManager.shared.createUser(email: email, password: password, username: nickname) { success in
                        if success {
                            completion(true)
                        } else {
                            AlertManager.shared.notUniqueEmailAlert(in: self.delegate!)
                            completion(false)
                        }
                    }
                }
            } else {
                AlertManager.shared.notUniqueUsernameAlert(in: self.delegate!)
                completion(false)
            }
        }
    }
}
