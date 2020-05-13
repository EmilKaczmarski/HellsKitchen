//
//  ChatViewController.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
class ChatViewController: UIViewController {
    
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
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.loadMessages()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel!.text = viewModel.messages[indexPath.row].message
        if viewModel.messages[indexPath.row].sender == sender {
            cell.textLabel?.textAlignment = .right
        } else {
            cell.textLabel?.textAlignment = .left
        }
        return cell
    }
    
    
}
