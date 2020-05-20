//
//  LoginViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import Firebase

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
