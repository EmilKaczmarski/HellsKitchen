//
//  WallViewController.swift
//  HellsKitchen
//
//  Created by Apple on 14/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import SnapKit
import DynamicColor

class WallViewController: UIViewController {
    
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var chatButton: UIBarButtonItem!
    @IBOutlet weak var addPostButton: UIBarButtonItem!
    let viewModel: WallViewModel = WallViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewParameters()
        viewModel.delegate = self
        setupNavigationBar()
        viewModel.loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Constants.currentUserName != "" {
            userIsLoggedIn()
        } else {
            userIsLoggedOut()
        }
    }
}

//MARK: -Enablers

extension WallViewController {
    private func userIsLoggedIn() {
        loginButton.title = "Account"
        chatButton.isEnabled = true
        addPostButton.isEnabled = true
        chatButton.tintColor = UIColor(hexaString: Constants.Colors.deepRed)
        addPostButton.tintColor = UIColor(hexaString: Constants.Colors.deepRed)
        navigationItem.title = Constants.currentUserName
    }
    
    private func userIsLoggedOut() {
        loginButton.title = "Login"
        //chatButton.isEnabled = false
        addPostButton.isEnabled = false
        addPostButton.tintColor = UIColor(hexaString: Constants.Colors.deepGreen)
        //chatButton.tintColor = UIColor(hexaString: Constants.Colors.deepGreen)
    }
}

//MARK: - setup view
extension WallViewController {
    private func setupTableViewParameters() {
        tableView.register(PostCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 85.0
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
}

//MARK: - setup navigation controller
extension WallViewController {
    private func setupNavigationBar(){
        navigationController?.navigationBar.tintColor = UIColor(hexaString: Constants.Colors.deepRed)
        navigationController?.navigationBar.barTintColor = UIColor(hexaString: Constants.Colors.deepGreen).lighter()
        let attributes = [NSAttributedString.Key.font : UIFont(name: Constants.Fonts.arialRounded, size: 18.0)!] as [NSAttributedString.Key : Any]
        
        loginButton.setTitleTextAttributes(attributes, for: .normal)
        loginButton.setTitleTextAttributes(attributes, for: .focused)
        loginButton.setTitleTextAttributes(attributes, for: .highlighted)
        loginButton.setTitleTextAttributes(attributes, for: .disabled)
        
        searchButton.setTitleTextAttributes(attributes, for: .normal)
        searchButton.setTitleTextAttributes(attributes, for: .focused)
        searchButton.setTitleTextAttributes(attributes, for: .highlighted)
        searchButton.setTitleTextAttributes(attributes, for: .disabled)

        chatButton.setTitleTextAttributes(attributes, for: .normal)
        chatButton.setTitleTextAttributes(attributes, for: .focused)
        chatButton.setTitleTextAttributes(attributes, for: .highlighted)
        chatButton.setTitleTextAttributes(attributes, for: .disabled)
        
        addPostButton.setTitleTextAttributes(attributes, for: .normal)
        addPostButton.setTitleTextAttributes(attributes, for: .focused)
        addPostButton.setTitleTextAttributes(attributes, for: .highlighted)
        addPostButton.setTitleTextAttributes(attributes, for: .disabled)
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
//MARK: - Delegate methods
extension WallViewController: UITableViewDelegate {
    
}


//MARK: - Datasource methods
extension WallViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostCell
        cell.content.text = viewModel.posts[indexPath.row].content
        cell.owner.text = viewModel.posts[indexPath.row].owner
        cell.title.text = viewModel.posts[indexPath.row].title
        let date = Date(timeIntervalSince1970: Double(viewModel.posts[indexPath.row].createTimestamp)!)
        cell.date.text = "\(date)"[0..<10]
        //temp section to show ui
        cell.postImage.image = UIImage(named: "pasta")
        cell.firstComment.text = "some first comment"
        cell.secondComment.text = "some second comment blabla"
        //end of temp section
        cell.selectionStyle = .none
        return cell
    }
}
