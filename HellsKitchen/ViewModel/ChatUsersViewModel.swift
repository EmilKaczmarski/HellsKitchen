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
    let db = Firestore.firestore()
    var delegate: ChatUsersViewController?
    var users = [String]()
    
    func setupView() {
        db.collection(Constants.FStore.allUsers).getDocuments { (querySnapshot, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    self.users = []
                    for i in snapshotDocuments {
                        let element = i.data()
                        if Constants.currentUserName != element[element.startIndex].key {
                        self.users.append(element[element.startIndex].key)
                        }
                    }
                }
                self.delegate!.tableView.reloadData()
            }
        }
    }
    
}
