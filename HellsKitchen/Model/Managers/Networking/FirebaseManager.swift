//
//  FirebaseManager.swift
//  HellsKitchen
//
//  Created by Apple on 23/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager {
    
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    var loginViewController: LoginViewController?
    var signInViewController: SignInMenuViewController?
    var registerViewController: RegisterViewController?
    func getCurrentUser()-> String {
        return Auth.auth().currentUser?.email ?? ""
    }
    
    enum ControllerType: String {
        case register, login
        var controller: UIViewController {
            switch self {
            case .login:
                return FirebaseManager.shared.signInViewController!
            case .register:
                return FirebaseManager.shared.registerViewController!
            }
        }
        
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
                        let element = i.data()
                        if (element[Constants.FStore.UserComponents.email] as! String) == email {
                            doesExist = true
                            completion(true)
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
                        let element = i.data()
                        if (element[Constants.FStore.UserComponents.username] as! String) == userName  {
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
                        if element["email"] as! String == Constants.currentUserEmail {
                            Constants.currentUserName = element["username"] as! String
                            UserDefaults.standard.set(element["email"] as! String, forKey: Constants.usernameKey)
                            completion()
                        }
                    }
                }
            }
            completion()
        }
    }
}

//MARK: - sing out
extension FirebaseManager {
    func signOutUser(completion: @escaping(Bool)-> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            Constants.currentUserName = ""
            completion(true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            completion(false)
        }
    }
}
//MARK: - method useful for sign in user by facebook

extension FirebaseManager {
    func signInWithExternalApplication(with credential: AuthCredential, type: ControllerType, completion: @escaping ()-> Void) {
        let controller = type.controller
        if type == .login {
            signInViewController!.loginLoader.startAnimating()
        }
        
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                completion()
            }
            guard let userEmail = Auth.auth().currentUser?.email else { return }
            FirebaseManager.shared.checkWhetherEmailExists(with: userEmail) { (doesExist) in
                if doesExist {
                    Constants.currentUserEmail = userEmail
                    FirebaseManager.shared.setCurrentUsername {
                        controller.navigationController?.popToRootViewController(animated: false)
                    }
                } else {
                    AlertManager.shared.askNewUserToProvideName(with: "please provide new username", in: controller)
                }
            }
            completion()
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
        db.collection(Constants.FStore.allUsers)
            .addDocument(data: [
                Constants.FStore.UserComponents.email: email,
                Constants.FStore.UserComponents.username: username
            ]) { (error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    
                }
        }
    }
}

//MARK: - profile details
extension FirebaseManager {
    func saveProfilePictureToFirebase(as data: Data) {
        let riversRef = storageRef.child("profilePictures/\(Constants.currentUserName).jpg")
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print(error)
                return
            }
            let size = metadata.size
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print(error)
                    return
                }
            }
        }
    }
}
//MARK: - profile pictures
extension FirebaseManager {
    func getProfilePictureData(for username: String, completion: @escaping (Data?, Error?)-> ()) {
        let pictureRef = storageRef.child("profilePictures/\(username).jpg")
        DispatchQueue.main.async {
            pictureRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, error)
                } else {
                    completion(data!, nil)
                }
            }
        }
    }
}

