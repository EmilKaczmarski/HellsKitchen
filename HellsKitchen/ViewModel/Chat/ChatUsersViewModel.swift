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
    var users = [String]()
    var allUsers = [String]()
    
    func loadFilteredData(by name: String) {
        users = allUsers.filter {
            $0.range(of: name, options: [.diacriticInsensitive, .caseInsensitive]) != nil
        }.sorted { $0 < $1 }
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
        self.allUsers = []
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
                            self.allUsers.append(element[element.startIndex].key)
                        }
                    }
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
                if result {
                    self.delegate!.dismiss(animated: true, completion: nil)
                }
            }
            self.users = self.allUsers
            self.delegate!.tableView.reloadData()
        }
    }
    
}

