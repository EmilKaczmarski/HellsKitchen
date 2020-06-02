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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MessageCell
        cell.data.text = viewModel.messages[indexPath.row].message
        if viewModel.messages[indexPath.row].sender == sender {
            cell.view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
            cell.rightView.isHidden = true
            cell.leftView.isHidden = false
        } else {
            cell.view.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 0.5, alpha: 1.0)
            cell.rightView.isHidden = false
            cell.leftView.isHidden = true
        }
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        return cell
    } 
}
