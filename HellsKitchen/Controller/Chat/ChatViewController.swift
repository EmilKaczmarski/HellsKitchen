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
    var sender: String?
    var receiver: String?
    
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
                    self.viewModel.sendMessage(message: self.messageTextView.text!, sender: self.sender!, receiver: self.receiver!)
                    
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
        if viewModel.messages[indexPath.row].sender == Constants.currentUserName {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rightCell") as! RightMessageCell
            cell.message.text = viewModel.messages[indexPath.row].message
            cell.message.text = viewModel.messages[indexPath.row].message
            cell.imageBox.image = UIImage(named: "defaultProfilePicture")
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
            cell.imageBox.image = UIImage(named: "defaultProfilePicture")
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
