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
    
    @IBOutlet weak var noPostsView: UIView!
    @IBOutlet weak var homeButton: UITabBarItem!
    @IBOutlet weak var searchButton: UITabBarItem!
    @IBOutlet weak var chatButton: UITabBarItem!
    @IBOutlet weak var addPostButton: UITabBarItem!
    @IBOutlet weak var profileButton: UITabBarItem!
    let viewModel: WallViewModel = WallViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewParameters()
        viewModel.delegate = self
        setupNavigationBar()
        viewModel.loadPosts()
        loadNoPostsView()
        tableView.separatorStyle = .none
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
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
        
    }
    
    private func userIsLoggedOut() {
    }
}

//MARK: - setup view
extension WallViewController {
    private func setupTableViewParameters() {
        
        let nib = UINib(nibName: "PostViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PostViewCell")
        //tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 85.0
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func loadNoPostsView() {
        if viewModel.posts.count == 0 {
            noPostsView.isHidden = false
        } else {
            noPostsView.isHidden = true
        }
    }
    
}

//MARK: - setup navigation controller
extension WallViewController {
    private func setupNavigationBar(){
        setTitle("hell's kitchen", andImage: #imageLiteral(resourceName: "fire"))
    }
}

extension WallViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Constants.currentUserName == "" {
            AlertManager.shared.requiedAuthorisationAlert(in: self)
        } else {
            performSegue(withIdentifier: Constants.Segues.wallDetailSegue, sender: self)
        }
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


/*//MARK: - Datasource methods
extension WallViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostViewCell", for: indexPath) as! PostViewCell
        //cell.content.text = viewModel.posts[indexPath.row].content
        cell.name.text = viewModel.posts[indexPath.row].owner
        cell.title.text = viewModel.posts[indexPath.row].title
        let date = Date(timeIntervalSince1970: Double(viewModel.posts[indexPath.row].createTimestamp)!)
        cell.date.text = "\(date)"[0..<10]
        //temp section to show ui
        cell.postImage.image = UIImage(named: "pasta")
        cell.profilePicture.image = UIImage(named: "pasta")
        //end of temp section
        cell.selectionStyle = .none
        return cell
    }
}
*/
