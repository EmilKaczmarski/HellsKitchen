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
    
    func signIn(email: String, password: String) {        
        let group = DispatchGroup()
        var didFinishWithError = false
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let err = error {
                didFinishWithError = true
                let alert = UIAlertController(title: "whoops something went wrong", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "try again", style: .cancel, handler: {
                    action in
                    // Called when user taps outside
                }))
                self.delegate?.present(alert, animated: false)
                print(err.localizedDescription)
            } else {
                if let user = Auth.auth().currentUser {
                    if user.isEmailVerified {
                        print("email verified")
                    } else {
                        print("no verified email")
                    }
                    Constants.currentUserEmail = user.email!
                    
                    //**SETTING USER NAME**//
                    group.enter()
                    self.db.collection(Constants.FStore.allUsers).getDocuments { (querySnapshot, error) in
                        if let err = error {
                            print(err.localizedDescription)
                        } else {
                            if let snapshotDocuments = querySnapshot?.documents {
                                for i in snapshotDocuments {
                                    let element = i.data()
                                    if element[element.startIndex].value as! String == Constants.currentUserEmail {
                                        Constants.currentUserName = element[element.startIndex].key
                                        UserDefaults.standard.set(element[element.startIndex].key, forKey: Constants.usernameKey)
                                    }
                                }
                            }
                        }
                        group.leave()
                    }
                    //**USERNAME HAS BEEN SET**//
                    
                    group.notify(queue: DispatchQueue.main) {
                        if !didFinishWithError {
                            self.delegate?.navigationController?.popViewController(animated: true)
                        } else {
                            let alert = UIAlertController(title: "error", message: "whoops something went wrong", preferredStyle: .alert)
                            self.delegate?.present(alert, animated: false)
                        }
                    }
                }
                
            }
        }
    }
}

extension LoginViewModel {
    
    func signInWithFacebook(with credential: AuthCredential) {
        print("sucesfully logged in with fb")
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            
            guard let userEmail = Auth.auth().currentUser?.email else { return }
            
            //****CHECK WHTHER USER EXISTS
            
            var emailExists = false
            //checking wheather nickname is available
            let group = DispatchGroup()
            group.enter()
            self.db.collection(Constants.FStore.allUsers).getDocuments { (querySnapshot, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for i in snapshotDocuments {
                            if i.data().values.contains(where: { (value) -> Bool in
                                return (value as! String) == userEmail
                            }) {
                                emailExists = true
                            }
                        }
                    }
                }
                group.leave()
            }
            
            group.notify(queue: DispatchQueue.main) {
                if emailExists {
                    //Constants.currentUserName =
                    Constants.currentUserEmail = userEmail
                } else {
                    self.askNewUserToProvideNameWindow(with: "please provide new username")
                }
            }
            //****END OF CHECK WHTHER USER EXISTS
            
            return
        }
    }
    
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
                    self.addUserToFirebase(name: username, email: userEmail)
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
    
    private func addUserToFirebase(name: String, email: String) {
        db.collection(Constants.FStore.allUsers).addDocument(data: [name: email]) { (error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                //success
            }
        }
        
    }
}
