//
//  WallViewController.swift
//  HellsKitchen
//
//  Created by Apple on 14/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import SnapKit

class WallViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var chatButton: UIBarButtonItem!
    @IBOutlet weak var addPostButton: UIBarButtonItem!
    let viewModel: WallViewModel = WallViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PostCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 85.0
        tableView.estimatedRowHeight = UITableView.automaticDimension
        viewModel.delegate = self
        viewModel.loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Constants.currentUserName != "" {
            loginButton.title = "Logout"
            chatButton.isEnabled = true
            addPostButton.isEnabled = true
            navigationItem.title = Constants.currentUserName
        } else {
            loginButton.title = "Login"
            chatButton.isEnabled = false
            addPostButton.isEnabled = false
        }
        
    }
}

extension WallViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Constants.currentUserName == "" {
            requiedAuthorisationAlert()
        } else {
            performSegue(withIdentifier: Constants.Segues.wallDetailSegue, sender: self)
        }
        
    }

    
    private func requiedAuthorisationAlert() {
        let alert = UIAlertController(title: "Please Log In", message: "Don't have an account? Register Now!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Log In", style: .cancel, handler: { (action) in
            self.performSegue(withIdentifier: Constants.Segues.loginSegue, sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: Constants.Segues.registerSegue, sender: self)
        }))
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if Constants.currentUserName != "" {
            if segue.identifier == Constants.Segues.wallDetailSegue {
                let vc = segue.destination as! PostDetailViewController
                if let indexPath = tableView.indexPathForSelectedRow {
                    vc.postId = viewModel.posts[indexPath.row].id
                }
            }
        }
    }
    
    
}

extension WallViewController: UITableViewDelegate {
    
}

extension WallViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostCell
        cell.content.text = viewModel.posts[indexPath.row].content
        cell.owner.text = viewModel.posts[indexPath.row].owner
        cell.title.text = viewModel.posts[indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }
}
