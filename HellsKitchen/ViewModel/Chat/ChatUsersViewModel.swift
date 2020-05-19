//
//  ChatUsersViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class ChatUsersViewModel {
    let db = Firestore.firestore()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        loadUsersFromCoreData()
        
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
                    self.processFinishedWithError()
                }
                return
            })
        }
        //loader presented
        self.allUsers = []
        db.collection(Constants.FStore.allUsers).getDocuments {
            (querySnapshot, error) in
            if let err = error {
                self.processFinishedWithError()
                print(err.localizedDescription)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for i in snapshotDocuments {
                        let element = i.data()
                        if element[element.startIndex].key != Constants.currentUserName {
                            self.allUsers.append(element[element.startIndex].key)
                            self.saveUserToCoreData(givenUserName: element[element.startIndex].key)
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
    
    private func processFinishedWithError() {
        let alert = UIAlertController(title: nil, message: "whoops something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "get back", style: .cancel, handler: { (action) in
            self.delegate?.navigationController?.popToRootViewController(animated: false)
        }))
        self.delegate?.present(alert, animated: true)
    }
}

//MARK: - core data
extension ChatUsersViewModel {
    
    func saveUserToCoreData(givenUserName name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
        let user = NSManagedObject(entity: entity, insertInto: context)
        user.setValue(name, forKey: "name")
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func loadUsersFromCoreData() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            users = try context.fetch(request).map { $0.name! }
        } catch {
            print("error while fetching users: \(error.localizedDescription)")
        }
    }
}
