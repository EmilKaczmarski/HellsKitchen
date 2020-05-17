//
//  ChatUsersViewController.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class ChatUsersViewController: UITableViewController {
    
    let viewModel: ChatUsersViewModel = ChatUsersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView.rowHeight = 70.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.setupView()
    }
}

extension ChatUsersViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel!.text = viewModel.users[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segues.chatUsersSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ChatViewController
        vc.sender = Constants.currentUserName
        if let indexPath = tableView.indexPathForSelectedRow {
            vc.receiver = viewModel.users[indexPath.row]
            vc.title = vc.receiver
        }
    }
}
