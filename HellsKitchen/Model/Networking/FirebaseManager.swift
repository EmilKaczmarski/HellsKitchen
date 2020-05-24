//
//  FirebaseManager.swift
//  HellsKitchen
//
//  Created by Apple on 23/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    
    func getCurrentUser()-> String {
        return Auth.auth().currentUser?.email ?? ""
    }
    
    func checkWhetherEmailExists(with email: String, completion: @escaping (Bool) -> Void ) {
        var doesExist = false
        db.collection(Constants.FStore.allUsers).getDocuments {
            (querySnapshot, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for i in snapshotDocuments {
                        if i.data().values.contains(where: { (value) -> Bool in
                            return (value as! String) == email
                        }) {
                            doesExist = true
                        }
                    }
                }
            }
            completion(doesExist)
        }
    }
    
    func checkWhetherUserExists(with userName: String, completion: @escaping (Bool) -> Void ) {
        var doesExist = false
        db.collection(Constants.FStore.allUsers).getDocuments {
            (querySnapshot, error) in
            
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for i in snapshotDocuments {
                        if i.data().keys.contains(where: { (key) -> Bool in
                            return key == userName
                        }) {
                            doesExist = true
                            completion(true)
                        }
                    }
                }
            }
            completion(doesExist)
        }
    }
    
    private func intit() {
    }
}
//MARK: - method useful for sign in user
extension FirebaseManager {
    func signIn(email: String, password: String, in controller: UIViewController, completion: @escaping ()-> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let err = error {
                let alertInfo = "whoops something went wrong"
                AlertManager.shared.textInputAlert(with: alertInfo, buttonTitle: "try again", for: controller)
                print(err.localizedDescription)
                completion()
            } else {
                guard let user = Auth.auth().currentUser else { return }
                Constants.currentUserEmail = user.email!
                self.setCurrentUsername() {
                    controller.navigationController?.popViewController(animated: true)
                    completion()
                }
            }
        }
    }
    
    
    func setCurrentUsername(completion: @escaping ()-> Void) {
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
                            completion()
                        }
                    }
                }
            }
            completion()
        }
    }
}


//MARK: - method useful for sign in user by facebook

extension FirebaseManager {
    func signInWithFacebook(with credential: AuthCredential, controller: UIViewController) {
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let userEmail = Auth.auth().currentUser?.email else { return }
    
            FirebaseManager.shared.checkWhetherEmailExists(with: userEmail) { (doesExist) in
                if doesExist {
                    Constants.currentUserEmail = userEmail
                    FirebaseManager.shared.setCurrentUsername {
                        controller.navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    AlertManager.shared.askNewUserToProvideName(with: "please provide new username", in: controller)
                }
            }
            return
        }
    }
}

//MARK: - method useful for register user
extension FirebaseManager {
    func createUser(email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error {
                print(err.localizedDescription)
            } else {
                Auth.auth().currentUser?.sendEmailVerification { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
                self.addUserToList(email: email, username: username)
            }
        }
    }
    
    func addUserToList(email: String, username: String) {
        db.collection(Constants.FStore.allUsers).addDocument(data: [username: email]) { (error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                
            }
        }
    }
    
}
