//
//  LoginViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//
import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewModel {
    
    let db = Firestore.firestore()
    var delegate: LoginViewController?
}

extension LoginViewModel {
    
    
    
    private func askNewUserToProvideNameWindow(with title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "new username"
        }
        alert.addAction(UIAlertAction(title: "done", style: .cancel, handler: {
            action in
            guard let username = alert.textFields![0].text else { return }
            
            var nicknameIsUnique = true
            //checking wheather nickname is available
            let group = DispatchGroup()
            group.enter()
            self.db.collection(Constants.FStore.allUsers).getDocuments { (querySnapshot, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for i in snapshotDocuments {
                            if i.data().keys.contains(where: { (key) -> Bool in
                                return key == username
                            }) {
                                nicknameIsUnique = false
                            }
                        }
                    }
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                if nicknameIsUnique {
                    guard let userEmail = Auth.auth().currentUser?.email else { return }
                    FirebaseManager.shared.addUserToList(email: userEmail, username: username)
                    Constants.currentUserName = username
                    Constants.currentUserEmail = userEmail
                    self.delegate?.navigationController?.popToRootViewController(animated: true)
                } else {
                    self.askNewUserToProvideNameWindow(with: "whoops username is not unique, please provide new one")
                }
            }
            
            
        }))
        delegate?.present(alert, animated: false)
    }
}
