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
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        var result = true
        
        delegate!.present(alert, animated: true) {
            group.leave()
            Timer.scheduledTimer(withTimeInterval: 7, repeats:false, block: {_ in
                if self.delegate?.presentedViewController == alert {
                    self.delegate!.dismiss(animated: true, completion: nil)
                    result = false
                    self.finishedWithError()
                }
                return
            })
        }
        //loader presented
        self.allUsers = []
        delegate!.db.collection(Constants.FStore.allUsers).getDocuments {
            (querySnapshot, error) in
            if let err = error {
                self.finishedWithError()
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
    
    private func finishedWithError() {
        let alert = UIAlertController(title: nil, message: "whoops something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "get back", style: .cancel, handler: { (action) in
            self.delegate?.navigationController?.popToRootViewController(animated: false)
        }))
        self.delegate?.present(alert, animated: true)
    }
}
