//
//  ChatUsersViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import Firebase

class ChatUsersViewModel {
    var delegate: ChatUsersViewController?
    var allMessages: [MessageBundle] = [MessageBundle]()
    var users: [User] = [User]()
    var userImages: [String: UIImage] = [String: UIImage]()
    var messageImages: [String: UIImage] = [String: UIImage]()
    var filteredUsers: [User] = [User]()
    var cells: [Any] = [Any]()
    
    func loadFilteredData(by name: String) {
        filteredUsers = users.filter {
            $0.name!.range(of: name, options: [.diacriticInsensitive, .caseInsensitive]) != nil
        }.sorted { $0.name! < $1.name! }
        cells = filteredUsers
        delegate?.tableView.reloadData()
    }
    
    func setupData() {
        let group = DispatchGroup()
        group.enter()
        var result = true
        
        let alert = AlertManager.shared.loadingAlert(in: self.delegate!) {
            group.leave()
        }
        AlertManager.shared.sheduleTimerFor(alert: alert, in: self.delegate!) { (success) in
            result = success
        }
        
        loadAllUsers() {
            self.delegate!.loadUserImages()
        }
        
        loadMessages() {
            group.notify(queue: DispatchQueue.main) {
                if result {
                    self.delegate!.dismiss(animated: true, completion: nil)
                    self.delegate!.loadMessageImages()
                }
            }
        }
    }
    
    func loadAllUsers(completion: @escaping()-> ()) {
        self.delegate!.db.collection(Constants.FStore.allUsers).getDocuments {
            (querySnapshot, error) in
            if let err = error {
                AlertManager.shared.errorAlert(in: self.delegate!)
                print(err.localizedDescription)
                completion()
            } else {
                self.users = []
                if let snapshotDocuments = querySnapshot?.documents {
                    for i in snapshotDocuments {
                        let element = i.data()
                        if (element["username"] as! String) != Constants.currentUserName {
                            let user = User()
                            user.name = (element["username"] as! String)
                            self.users.append(user)
                            self.delegate?.tableView.reloadData()
                        }
                    }
                    self.filteredUsers = self.users
                    completion()
                }
            }
        }
    }
    
    func loadMessages(completion: @escaping ()-> ()) {
        self.delegate!.db.collection(Constants.FStore.allMessages).addSnapshotListener {
            (querySnapshot, error) in
            if let err = error {
                AlertManager.shared.errorAlert(in: self.delegate!)
                print(err.localizedDescription)
                completion()
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    self.cells = []
                    self.allMessages = []
                    for i in snapshotDocuments {
                        var isFound = false
                        let element = i.data()
                        for (value) in element.values {
                            if (value as! String) == Constants.currentUserName {
                                isFound = true
                            }
                        }
                        
                        if isFound {
                            var messageBundle = MessageBundle()
                            messageBundle.firstUsername = element["firstUser"] as? String
                            messageBundle.secondUsername = element["secondUser"] as? String
                            messageBundle.timestamp = element["timestamp"] as? String
                            messageBundle.lastMessage = element["lastMessage"] as? String
                            self.allMessages.append(messageBundle)
                        }
                    }
                }
            }
            self.cells = self.allMessages
            self.delegate!.loadMessageImages()
            self.delegate!.loadUserImages()
            self.delegate!.tableView.reloadData()
            completion()
        }
    }
}

extension ChatUsersViewModel {
    func setUserProfilePicture(for user: User, completion: @escaping()-> ()) {
        FirebaseManager.shared.getProfilePictureData(for: user.name!) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                user.profilePicture = Constants.Pictures.defaultProfile
                completion()
                return
            }
            user.profilePicture = UIImage(data: data!)
            completion()
        }
    }
    
    func setMessageProfilePicture(in message: MessageBundle, for username: String, completion: @escaping()-> ()) {
        FirebaseManager.shared.getProfilePictureData(for: username) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                message.profilePicture = Constants.Pictures.defaultProfile
                completion()
                return
            }
            message.profilePicture = UIImage(data: data!)
            completion()
        }
    }
    
}
