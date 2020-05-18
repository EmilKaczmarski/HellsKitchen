//
//  ChatUsersViewController.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class ChatUsersViewController: UITableViewController {
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let viewModel: ChatUsersViewModel = ChatUsersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView.register(ChatUserCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = CGFloat(Constants.Sizes.chatViewCellHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.setupData()
        hideLoup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        hideLoup()
    }
    
    @IBAction func loupePressed(_ sender: UIBarButtonItem) {
        if tableView.tableHeaderView!.frame.size.height == 0 {
            showLoup()
        } else {
            hideLoup()
        }
        tableView.reloadData()
    }
}

//MARK: - loup methods
extension ChatUsersViewController {
    func hideLoup() {
        tableView.tableHeaderView!.frame.size.height = 0
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func showLoup() {
        tableView.tableHeaderView!.frame.size.height = 40
        searchBar.becomeFirstResponder()
    }
}

//MARK: - tableview delegate, datasource methods
extension ChatUsersViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ChatUserCell.username = viewModel.users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChatUserCell
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
        hideLoup()
    }
    
    func loadAllUsers() {
        viewModel.users = viewModel.allUsers
        tableView.reloadData()
    }
}

//MARK: -searchbar delegate
extension ChatUsersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadAllUsers()
        } else {
            viewModel.loadFilteredData(by: searchBar.text!)
        }
    }
}
