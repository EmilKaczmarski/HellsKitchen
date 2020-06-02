//
//  ChatUsersViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import Firebase

class ChatUsersViewModel {
    var delegate: ChatUsersViewController?
    var allMessages: [MessageBundle] = [MessageBundle]()
    var users: [User] = [User]()
    var filteredUsers: [User] = [User]()
    var cells: [Any] = [Any]()
    
    func loadFilteredData(by name: String) {
        filteredUsers = users.filter {
            $0.name!.range(of: name, options: [.diacriticInsensitive, .caseInsensitive]) != nil
        }.sorted { $0.name! < $1.name! }
        cells = []
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
        
        loadAllUsers()
        
        loadMessages() {
            group.notify(queue: DispatchQueue.main) {
                if result {
                    self.delegate!.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func loadAllUsers() {
        self.delegate!.db.collection(Constants.FStore.allUsers).getDocuments {
            (querySnapshot, error) in
            if let err = error {
                AlertManager.shared.errorAlert(in: self.delegate!)
                print(err.localizedDescription)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for i in snapshotDocuments {
                        let element = i.data()
                        if element[element.startIndex].key != Constants.currentUserName {
                            var user = User()
                            user.name = element[element.startIndex].key
                            self.users.append(user)
                        }
                    }
                    self.filteredUsers = self.users
                }
            }
        }
    }
    
    func loadMessages(completion: @escaping ()-> ()) {
        self.allMessages = []
        self.delegate!.db.collection(Constants.FStore.allMessages).getDocuments {
            (querySnapshot, error) in
            
            if let err = error {
                AlertManager.shared.errorAlert(in: self.delegate!)
                print(err.localizedDescription)
                completion()
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
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
                            for (key, value) in element {
                                if key == "firstUser" {
                                    messageBundle.firstUser = (value as! String)
                                }
                                if key == "secondUser" {
                                    messageBundle.secondUser = (value as! String)
                                }
                                if key == "timestamp" {
                                    messageBundle.timestamp = (value as! String)
                                }
                            }
                            self.allMessages.append(messageBundle)
                        }
                    }
                }
            }
            self.cells = self.allMessages
            self.delegate!.tableView.reloadData()
            completion()
        }
    }
}

