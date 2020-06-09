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
    
    @IBOutlet weak var searchBarView: UIView!
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
        setTitle("hell's kitchen", andImage: #imageLiteral(resourceName: "fire"))
        tableView.register(ChatUserCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = CGFloat(Constants.Sizes.chatViewCellHeight)
        setupSearchBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Constants.currentUserName != "" {
            navigationController?.popToRootViewController(animated: false)
        }
        super.viewWillAppear(true)
        enableFirebaseToOfflineMode()
        viewModel.setupData()
        setupBackButtonTitle()
        hidecarrotViewIfNeeded()
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tabBarController?.tabBar.isHidden = false
    }
    
    func enableFirebaseToOfflineMode() {
        // [START enable_offline]
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        // Enable offline data persistence
        db.settings = settings
        // [END enable_offline]
    }
    
    func setupSearchBar() {
        searchBarView.layer.cornerRadius = 25
        searchBarView.layer.borderWidth = 1
        searchBarView.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.searchTextField.backgroundColor = .white
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
        if viewModel.cells.count == 0 {
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
        
        if viewModel.cells[indexPath.row] is MessageBundle {
            let message = viewModel.cells[indexPath.row] as! MessageBundle
            if message.firstUser == Constants.currentUserName {
                cell.name.text = message.secondUser!
            } else {
                cell.name.text = message.firstUser!
            }
            if let date = Double(message.timestamp!) {
                cell.date.text = TimeDisplayManager.shared.getDateForUserCell(timestamp: date)
            }
            
            cell.lastMessage.isHidden = false
            cell.date.isHidden = false
            cell.lastMessage.isHidden = false
            cell.lastMessage.text = message.lastMessage
        } else if viewModel.cells[indexPath.row] is User{
            let user = viewModel.cells[indexPath.row] as! User
            cell.name.text = user.name
            cell.lastMessage.isHidden = true
            cell.date.isHidden = true
            cell.lastMessage.isHidden = true
        }
        cell.imageBox.image = UIImage(named: "test")
        hidecarrotViewIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segues.chatUsersSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ChatViewController
        vc.sender = Constants.currentUserName
        if let indexPath = tableView.indexPathForSelectedRow {
            var receiver = ""
            if viewModel.cells[indexPath.row] is MessageBundle {
                let message = viewModel.cells[indexPath.row] as! MessageBundle
                if message.firstUser == Constants.currentUserName {
                    receiver = message.secondUser!
                } else {
                    receiver = message.firstUser!
                }
            } else if viewModel.cells[indexPath.row] is User{
                let user = viewModel.cells[indexPath.row] as! User
                receiver = user.name!
            }
            vc.receiver = receiver
            vc.setTitle(vc.receiver!)
        }
    }
    
    func loadUsers() {
        viewModel.cells = viewModel.allMessages
        tableView.reloadData()
    }
    
    func loadFromAllUsers() {
        
    }
}

//MARK: -searchbar delegate
extension ChatUsersViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadUsers()
        } else {
            viewModel.loadFilteredData(by: searchBar.text!)
        }
    }
}
