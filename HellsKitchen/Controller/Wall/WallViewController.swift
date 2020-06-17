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
    
    
    @IBOutlet weak var carrotView: UIStackView!
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
        viewModel.delegate = self
        setupNavigationBar()
        loadNoPostsView()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        if viewModel.posts.count == 0 {
            viewModel.loadPosts()
        }
        setupTableViewParameters()
        if Constants.currentUserName != "" {
            userIsLoggedIn()
        } else {
            userIsLoggedOut()
        }
        tableView.reloadData()
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 340.0
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
        setTitle("", andImage: #imageLiteral(resourceName: "logo"))
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
                    vc.post = viewModel.posts[indexPath.row]
                    let postId = viewModel.posts[indexPath.row].id
                    vc.postImage = viewModel.postsImages[postId]
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
        if viewModel.posts.count == 0 {
            noPostsView.isHidden = false
        } else {
            noPostsView.isHidden = true
        }
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostViewCell", for: indexPath) as! PostViewCell
        let owner = viewModel.posts[indexPath.row].owner
        cell.name.text = owner
        cell.title.text = viewModel.posts[indexPath.row].title
        let createTimestamp = Double(viewModel.posts[indexPath.row].createTimestamp)
        cell.date.text = TimeDisplayManager.shared.getDateForPostCell(timestamp: createTimestamp!)
        let postId = "\(owner)\(Int(viewModel.posts[indexPath.row].createTimestamp)!)"
        if let image = viewModel.postsImages[postId] {
            cell.postImage.image = image
        } else {
            cell.postImage.image = Constants.Pictures.defaultPost
        }
        
        if let image = viewModel.usersImages[owner] {
            cell.profilePicture.image = image
        } else {
            cell.profilePicture.image = Constants.Pictures.defaultProfile
        }
        //end of temp section
        let screenSize: CGRect = UIScreen.main.bounds
        if screenSize.width > 375 {
            let viewWidth = (screenSize.width - cell.middleView.frame.width)/2
            cell.leftView.snp.makeConstraints { (maker) in
                maker.width.equalTo(viewWidth)
            }
            
            cell.rightView.snp.makeConstraints { (maker) in
                maker.width.equalTo(viewWidth)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
}
