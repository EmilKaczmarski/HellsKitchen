//
//  ChatViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class ChatViewModel {
    let db = Firestore.firestore()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: ChatViewController?
    var messages = [MessageModel]()
    
    lazy var messagesId: String = {
        var id = "trash"
        if let sender = delegate!.sender, let receiver = delegate!.receiver {
            if sender < receiver {
                id = sender + "@" + receiver
            } else {
                id = receiver + "@" + sender
            }
        }
        return id
    }()
}

//MARK: -Core Data
extension ChatViewModel {
    
    func loadSavedMessages() {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "conversationId = '\(messagesId)' ")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        do {
            let preformattedMessages = try context.fetch(request)
            messages = preformattedMessages.map({ (message) in
                let sender = Constants.currentUserName != message.firstUser ? message.firstUser : message.secondUser
                return MessageModel(message: message.content!, sender: sender!, timestamp: message.timestamp!)
            })
        } catch {
            print("error while fetching data in chat: \(error.localizedDescription)")
        }
        delegate?.tableView.reloadData()
    }
    
    func saveMessage(_ mess: MessageModel) {
        if checkWhetherMessageExists(mess) {
            return
        }
        let entity =
            NSEntityDescription.entity(forEntityName: "Message",
                                       in: context)!
        let message = NSManagedObject(entity: entity,
                                      insertInto: context)
        
        message.setValue(mess.message, forKey: "content")
        message.setValue(Constants.currentUserName, forKey: "firstUser")
        message.setValue(mess.sender, forKey: "secondUser")
        message.setValue(messagesId, forKey: "conversationId")
        message.setValue(mess.timestamp, forKey: "timestamp")
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func checkWhetherMessageExists(_ mess: MessageModel)-> Bool {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "conversationId = '\(messagesId)' ")
        var messagesInDataBase = [Message]()
        do {
            messagesInDataBase = try context.fetch(request)
        } catch {
            print("error while checking duplicate messages")
        }
        return messagesInDataBase.contains { (message) -> Bool in
            if message.content == mess.message {
                if message.timestamp == mess.timestamp {
                    return true
                }
            }
            return false
        }
        
    }
    
}

//MARK: - Cloud

extension ChatViewModel {
    func loadMessagesFromCloud() {
        db
            .collection(Constants.FStore.allMessages)
            .document(messagesId)
            .collection(Constants.FStore.messages)
            .order(by: Constants.FStore.MessageComponents.timestamp)
            .addSnapshotListener { (querySnapshot, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    self.messages = []
                    if let snapshotDocuments = querySnapshot?.documents {
                        for i in snapshotDocuments {
                            let data = i.data()
                            let message = MessageModel(
                                message: data["message"] as! String,
                                sender: data["sender"] as! String,
                                timestamp: "\(data["timestamp"]!)")
                            self.messages.append(message)
                            DispatchQueue.main.async {
                                self.saveMessage(message)
                            }
                        }
                    }
                    self.delegate!.tableView.reloadData()
                    if self.messages.count > 0 {
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.delegate!.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
        }
    }
    
    func sendMessage(message: String, sender: String, receiver: String) {
        let mess = MessageModel(message: message, sender: sender, timestamp: "\(Date().timeIntervalSince1970)")
        
        db.collection(Constants.FStore.messages)
            .document(self.messagesId).setData(
                [
                    Constants.FStore.MessageDocumentComponents.firstUser  : mess.sender,
                    Constants.FStore.MessageDocumentComponents.secondUser : receiver,
                    Constants.FStore.MessageDocumentComponents.timestamp : mess.timestamp
            ])
        
        db.collection(Constants.FStore.messages)
            .document(self.messagesId)
            .collection(Constants.FStore.messages)
            .addDocument(data:
                [
                    Constants.FStore.MessageComponents.sender : mess.sender,
                    Constants.FStore.MessageComponents.message   : mess.message,
                    Constants.FStore.MessageComponents.timestamp : mess.timestamp
            ] )
        
        self.messages.append(mess)
        DispatchQueue.main.async {
            self.saveMessage(mess)
            self.delegate!.tableView.reloadData()
        }
        self.delegate!.view.endEditing(true)
    }
    
}
