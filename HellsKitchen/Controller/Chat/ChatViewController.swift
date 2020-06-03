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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var message: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MessageCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 85.0
        tableView.estimatedRowHeight = UITableView.automaticDimension
        viewModel.delegate = self
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
                if self.message.text! != "" {
                    self.viewModel.sendMessage(message: self.message.text!, sender: self.sender!, receiver: self.receiver!)
                    
                }
                self.message.text! = ""
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RightMessageCell
            cell.message.text = viewModel.messages[indexPath.row].message
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LeftMessageCell
            cell.message.text = viewModel.messages[indexPath.row].message
            return cell
        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MessageCell
//        cell.message.text = viewModel.messages[indexPath.row].message
//        cell.date.text = "2020-01-01"
//        cell.imageBox.image = UIImage(named: "test")
//        cell.selectionStyle = .none
//        cell.backgroundColor = .clear
//        return cell
    } 
}
