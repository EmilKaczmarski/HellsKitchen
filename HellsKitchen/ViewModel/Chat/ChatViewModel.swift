//
//  ChatViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import Firebase


class ChatViewModel {
    var delegate: ChatViewController?
    var messages = [MessageModel]()
    
    lazy var messagesId: String = {
        var id = "trash"
        if let senderEmail = delegate!.senderEmail, let receiverEmail = delegate!.receiverEmail {
            if senderEmail < receiverEmail {
                id = senderEmail + "@" + receiverEmail
            } else {
                id = receiverEmail + "@" + senderEmail
            }
        }
        return id
    }()
}

//MARK: - Cloud

extension ChatViewModel {
    func loadMessagesFromCloud() {
        delegate!.db
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
                            var message = MessageModel()
                            message.message = data["message"] as? String
                            message.senderEmail = data["senderEmail"] as? String
                            message.timestamp = "\(data["timestamp"]!)"
                            self.messages.append(message)
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
    
    func sendMessage(message: String, senderEmail: String, senderUsername: String , receiverEmail: String, receiverUsername: String) {
        let mess = MessageModel(message: message, senderEmail: senderEmail, timestamp: "\(Date().timeIntervalSince1970)")
        delegate!.db.collection(Constants.FStore.messages)
            .document(self.messagesId).setData(
                [
                    Constants.FStore.MessageDocumentComponents.firstUserEmail  : mess.senderEmail!,
                    Constants.FStore.MessageDocumentComponents.secondUserEmail : receiverEmail,
                    Constants.FStore.MessageDocumentComponents.timestamp : mess.timestamp!,
                    Constants.FStore.MessageDocumentComponents.lastMessage : message,
                    Constants.FStore.MessageDocumentComponents.firstUserName : senderUsername,
                    Constants.FStore.MessageDocumentComponents.secondUserName : receiverUsername
            ])
        
        delegate!.db.collection(Constants.FStore.messages)
            .document(self.messagesId)
            .collection(Constants.FStore.messages)
            .addDocument(data:
                [
                    Constants.FStore.MessageComponents.senderEmail : mess.senderEmail!,
                    Constants.FStore.MessageComponents.message   : mess.message!,
                    Constants.FStore.MessageComponents.timestamp : mess.timestamp!
            ] )
        
        self.messages.append(mess)
        DispatchQueue.main.async {
            self.delegate!.tableView.reloadData()
        }
        self.delegate!.view.endEditing(true)
    }
    
}
