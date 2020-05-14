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
}

extension WallViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segues.wallDetailSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.wallDetailSegue {
            let vc = segue.destination as! PostDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.postId = viewModel.posts[indexPath.row].id
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
