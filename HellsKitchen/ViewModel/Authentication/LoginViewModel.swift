//
//  LoginViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import Firebase

class LoginViewModel {
    
    let db = Firestore.firestore()
    
    var delegate: LoginViewController?
    
    
    func signIn(email: String, password: String) {
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
                    
                    Constants.currentUserEmail = user.email!
                    self.setUserName()
                    
                }
                self.delegate!.performSegue(withIdentifier: Constants.Segues.loginSegue, sender: self.delegate)
            }
        }
    }
    
    private func setUserName() {
        db.collection(Constants.FStore.allUsers).getDocuments { (querySnapshot, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for i in snapshotDocuments {
                        let element = i.data()
                        if element[element.startIndex].value as! String == Constants.currentUserEmail {
                            Constants.currentUserName = element[element.startIndex].key
                        }
                    }
                }
            }
        }
    }
    
}
