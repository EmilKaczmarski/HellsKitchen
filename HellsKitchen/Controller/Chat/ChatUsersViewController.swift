//
//  ChatUsersViewController.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import Firebase

class ChatUsersViewController: UIViewController {
    
    @IBOutlet weak var carrotView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    let db = Firestore.firestore()
    let viewModel: ChatUsersViewModel = ChatUsersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 71
        tableView.register(ChatUserCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = CGFloat(Constants.Sizes.chatViewCellHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        enableFirebaseToOfflineMode()
        viewModel.setupData()
        setupBackButtonTitle()
        hidecarrotViewIfNeeded()
        print(viewModel.allUsers.count)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
}

//MARK: - noUsersView methods
extension ChatUsersViewController {
    func hidecarrotViewIfNeeded() {
        if viewModel.allUsers.count == 0 {
            carrotView.isHidden = false
        } else {
            carrotView.isHidden = true
        }
    }
}


//MARK: - tableview delegate, datasource methods
extension ChatUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChatUserCell
        cell.name.text = viewModel.users[indexPath.row]
        cell.imageBox.image = UIImage(named: "test")
        cell.date.text = "yesterday"
        cell.lastMessage.text = "blabla"
        hidecarrotViewIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func loadAllUsers() {
        viewModel.users = viewModel.allUsers
        tableView.reloadData()
    }
}

//MARK: -searchbar delegate
extension ChatUsersViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadAllUsers()
        } else {
            viewModel.loadFilteredData(by: searchBar.text!)
        }
    }
}
