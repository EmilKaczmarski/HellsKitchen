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
import FacebookCore
import FBSDKLoginKit
import GoogleSignIn

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
    func signIn(email: String, password: String, in controller: UIViewController, completion: @escaping (Bool)-> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let err = error {
                AlertManager.shared.loginAlert(in: controller)
                print(err.localizedDescription)
                completion(false)
            } else {
                guard let user = Auth.auth().currentUser else { return }
                if user.isEmailVerified {
                    Constants.currentUserEmail = user.email!
                    self.setCurrentUserInfo {
                        completion(true)
                    }
                } else {
                    AlertManager.shared.verifyEmailAlert(in: controller) {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func setCurrentUserInfo(completion: @escaping ()-> Void) {
        self.db.collection(Constants.FStore.allUsers).getDocuments { (querySnapshot, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for i in snapshotDocuments {
                        let element = i.data()
                        if element["email"] as! String == Constants.currentUserEmail {
                            Constants.hasDefaultImage = (element["hasDefaultImage"] as! Bool)
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
        LoginManager().logOut()
        do {
            try firebaseAuth.signOut()
            Constants.currentUserName = ""
            AccessToken.current = nil
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
                    FirebaseManager.shared.setCurrentUserInfo {
                        controller.navigationController?.popToRootViewController(animated: false)
                        completion()
                    }
                } else {
                    AlertManager.shared.askNewUserToProvideName(with: "Please provide new username", in: controller)
                }
            }
        }
    }
}

//MARK: - method useful for register user
extension FirebaseManager {
    func createUser(email: String, password: String, username: String, completion: @escaping (Bool)-> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error {
                print(err.localizedDescription)
                completion(false)
            } else {
                Auth.auth().currentUser?.sendEmailVerification { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                    }
                }
                self.addUserToList(email: email, username: username)
                completion(true)
            }
        }
    }
    
    func addUserToList(email: String, username: String) {
        db.collection(Constants.FStore.allUsers)
            .addDocument(data: [
                Constants.FStore.UserComponents.email: email,
                Constants.FStore.UserComponents.username: username,
                Constants.FStore.UserComponents.hasDefaultImage: true
            ]) { (error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    
                }
        }
    }
}

//MARK: - saving images to database
extension FirebaseManager {
    func saveProfilePictureToFirebase(as data: Data) {
        let dbRef = storageRef.child("profilePictures/\(Constants.currentUserEmail).jpg")
        let uploadTask = dbRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print(error)
                return
            }
            let size = metadata.size
            dbRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print(error)
                    return
                }
            }
        }
    }
    
    func savePostPictureToFirebase(as data: Data, for postId: String) {
        let dbRef = storageRef.child("postPictures/\(postId).jpg")
        let uploadTask = dbRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            let size = metadata.size
            dbRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
            }
        }
    }
}
//MARK: - profile pictures
extension FirebaseManager {
    func getProfilePictureData(for email: String, completion: @escaping (Data?, Error?)-> ()) {
        let pictureRef = storageRef.child("profilePictures/\(email).jpg")
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
    
    func getPostPictureData(for postId: String, completion: @escaping (Data?, Error?)-> ()) {
        let pictureRef = storageRef.child("postPictures/\(postId).jpg")
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
    
    func imageHasChanged() {
        if !Constants.hasDefaultImage! {
            return
        }
        Constants.hasDefaultImage = false
        db.collection(Constants.FStore.allUsers).getDocuments { (querySnapshot, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for i in snapshotDocuments {
                        var element = i.data()
                        if element["email"] as! String == Constants.currentUserEmail {
                            self.db.collection("allUsers").document(i.documentID).setData(["hasDefaultImage": false], merge: true)
                            element.updateValue(false, forKey: "hasDefaultImage")
                            return
                        }
                    }
                }
            }
        }
    }
}

//MARK: - removing account
extension FirebaseManager {
    func removeAccount(completion: @escaping (Bool)-> ()) {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                self.removeAccountFromUserList { (success) in
                    if success {
                        self.removeProfilePictureFromCloudForCurrentUser {
                            Constants.currentUserName = ""
                            Constants.currentUserEmail = ""
                            Constants.currentUserProfilePicture = Constants.Pictures.defaultProfile
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    
    func removeAccountFromUserList(completion: @escaping (Bool)-> ()) {
        self.getDocumentIdForCurrentUser { (id) in
            if id == "" {
                completion(false)
                return
            }
            
            self.db.collection(Constants.FStore.allUsers).document(id).delete() { err in
                if let err = err {
                    print(err.localizedDescription)
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    func getUsernameForGivenEmail(_ email: String, completion: @escaping (String)-> ()) {
        db.collection(Constants.FStore.allUsers).getDocuments { (querySnapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                completion("")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for i in snapshotDocuments {
                        let element = i.data()
                        if element["email"]! as! String == email {
                            completion(element["username"]! as! String )
                        }
                    }
                }
            }
        }
    }
    
    func getDocumentIdForCurrentUser(completion: @escaping (String)-> ()) {
        db.collection(Constants.FStore.allUsers).getDocuments { (querySnapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                completion("")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for i in snapshotDocuments {
                        let element = i.data()
                        if element["email"]! as! String == Constants.currentUserEmail {
                            completion(i.documentID)
                        }
                    }
                }
            }
        }
    }
    
    func removeProfilePictureFromCloudForCurrentUser(completion: @escaping ()-> ()) {
        let picture = storageRef.child("profilePictures/\(Constants.currentUserName).jpg")
        // Delete the file
        picture.delete { error in
            if let error = error {
                print(error.localizedDescription)
                completion()
            } else {
                completion()
            }
        }
    }
    
}

//MARK: - change username
extension FirebaseManager {
    
    
    func changeUsername(to username: String, completion: @escaping (Bool)-> ()) {
        self.changeUsernameInAllUsers(to: username) { (success) in
            if !success {
                completion(false)
                return
            }
            self.changeUsernameInAllMessages(to: username) { (success) in
                if !success {
                    completion(false)
                    return
                }
                self.changeUsernameInAllPosts(to: username) { (success) in
                    if !success {
                        completion(false)
                        return
                    }
                    Constants.currentUserName = username
                    completion(true)
                }
            }
        }
    }
    
    func changeUsernameInAllMessages(to username: String, completion: @escaping (Bool)-> ()) {
        self.db.collection(Constants.FStore.messages).getDocuments { (querySnapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(false)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for i in snapshotDocuments {
                        var element = i.data()
                        if element["firstUserEmail"] as! String == Constants.currentUserEmail {
                            self.db.collection(Constants.FStore.messages).document(i.documentID).setData(["firstUserName": username], merge: true)
                            element.updateValue(username, forKey: "firstUserName")
                        }
                        if element["secondUserEmail"] as! String == Constants.currentUserEmail {
                            self.db.collection(Constants.FStore.messages).document(i.documentID).setData(["secondUserName": username], merge: true)
                            element.updateValue(username, forKey: "secondUserName")
                        }
                    }
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func changeUsernameInAllPosts(to username: String, completion: @escaping (Bool)-> ()) {
        self.db.collection(Constants.FStore.posts).getDocuments { (querySnapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(false)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for i in snapshotDocuments {
                        var element = i.data()
                        if element["ownerEmail"] as! String == Constants.currentUserEmail {
                            self.db.collection(Constants.FStore.posts).document(i.documentID).setData(["ownerName": username], merge: true)
                            element.updateValue(username, forKey: "ownerName")
                        }
                    }
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    
    func changeUsernameInAllUsers(to username: String, completion: @escaping (Bool)-> ()) {
        self.getDocumentIdForCurrentUser { (id) in
            if id == "" {
                completion(false)
                return
            }
            self.db.collection(Constants.FStore.allUsers).getDocuments { (querySnapshot, error) in
                if let err = error {
                    print(err.localizedDescription)
                    completion(false)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for i in snapshotDocuments {
                            var element = i.data()
                            if element["email"] as! String == Constants.currentUserEmail {
                                self.db.collection("allUsers").document(i.documentID).setData(["username": username], merge: true)
                                element.updateValue(username, forKey: "username")
                                completion(true)
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    //MARK: - change password
    func changePassword(to password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
            completion(error)
        })
    }
    
    func isUserSingedWithFbOrGoogle()-> Bool {
        if AccessToken.current != nil {
            return true
        }
        if let instance = GIDSignIn.sharedInstance() {
            if instance.currentUser != nil {
                if let email = instance.currentUser.profile.email {
                    return email == Constants.currentUserEmail
                }
            }
        }
        return false
    }
}
