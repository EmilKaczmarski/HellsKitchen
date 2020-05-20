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
        
        if nickname.contains("@") {
            print("nickname can't contain @")
            return
        }
        
        var nicknameIsUnique = true
        //checking wheather nickname is available
        let group = DispatchGroup()
        group.enter()
        db.collection(Constants.FStore.allUsers).getDocuments { (querySnapshot, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for i in snapshotDocuments {
                        if i.data().keys.contains(where: { (key) -> Bool in
                            return key == nickname
                        }) {
                            nicknameIsUnique = false
                        }
                    }
                }
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            if nicknameIsUnique {
                if let email = emailTextField, let password = passwordTextField {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let err = error {
                            print(err.localizedDescription)
                        } else {
                            Auth.auth().currentUser?.sendEmailVerification { (error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                            
                            //adding user to list of users
                            self.db.collection(Constants.FStore.allUsers).addDocument(data: [nickname: email]) { (error) in
                                if let err = error {
                                    print(err.localizedDescription)
                                } else {
                                    //success
                                }
                            }
                            self.delegate!.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
            }  else {
                print("user with given username already exists")
            }
        }
    }
}
