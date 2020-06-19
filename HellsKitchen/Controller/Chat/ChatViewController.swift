//
//  ChatViewController.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    let db = Firestore.firestore()
    var senderEmail: String?
    var receiverEmail: String?
    var senderUsername: String?
    var receiverUsername: String?
    var receiverProfilePicture: UIImage?
    let viewModel: ChatViewModel = ChatViewModel()
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LeftMessageCell.self, forCellReuseIdentifier: "leftCell")
        tableView.register(RightMessageCell.self, forCellReuseIdentifier: "rightCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 85.0
        tableView.estimatedRowHeight = UITableView.automaticDimension
        viewModel.delegate = self
        messageTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        enableFirebaseToOfflineMode()
        viewModel.loadMessagesFromCloud()
        setupBackButtonTitle()
        tabBarController?.tabBar.isHidden = true
    }
    
    
    func enableFirebaseToOfflineMode() {
        // [START enable_offline]
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        // Enable offline data persistence
        db.settings = settings
        // [END enable_offline]
    }
    
    func setupBackButtonTitle() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        AlertManager.shared.isInternetAvailable { (success) in
            if success {
                if self.messageTextView.text! != "" {
                    self.viewModel.sendMessage(message: self.messageTextView.text!, senderEmail: self.senderEmail!, senderUsername: self.senderUsername! , receiverEmail: self.receiverEmail!, receiverUsername: self.receiverUsername!)
                    
                }
                self.messageTextView.text! = ""
            } else {
                AlertManager.shared.sendMessageAlert(in: self)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

//MARK:- Messages handling
extension ChatViewController {
    
}

extension ChatViewController: UITableViewDelegate {
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(viewModel.messages[indexPath.row].senderEmail)
        print(Constants.currentUserEmail)
        if viewModel.messages[indexPath.row].senderEmail == Constants.currentUserEmail {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rightCell") as! RightMessageCell
            cell.message.text = viewModel.messages[indexPath.row].message
            cell.message.text = viewModel.messages[indexPath.row].message
            cell.imageBox.image = Constants.currentUserProfilePicture
            if let date = Double(viewModel.messages[indexPath.row].timestamp!) {
                cell.date.text = TimeDisplayManager.shared.getDateForMessageCell(timestamp: date)
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "leftCell") as! LeftMessageCell
            cell.message.text = viewModel.messages[indexPath.row].message
            if let date = Double(viewModel.messages[indexPath.row].timestamp!) {
                cell.date.text = TimeDisplayManager.shared.getDateForMessageCell(timestamp: date)
            }
            cell.imageBox.image = receiverProfilePicture ?? Constants.Pictures.defaultProfile
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        }
    } 
}

//MARK: -textview delegate
extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        bottomView.sizeToFit()
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
