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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        enableFirebaseToOfflineMode()
        viewModel.loadMessagesFromCloud()
        setupBackButtonTitle()
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
        if message.text! != "" {
            viewModel.sendMessage(message: message.text!, sender: self.sender!, receiver: receiver!)
                
        }
        message.text! = ""
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! //as! MessageCell
        cell.textLabel!.text = viewModel.messages[indexPath.row].message
        if viewModel.messages[indexPath.row].sender == sender {
            //our message
            cell.textLabel?.textAlignment = .right
        } else {
            //messege of other user
            cell.textLabel?.textAlignment = .left
        }
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        return cell
    } 
}
