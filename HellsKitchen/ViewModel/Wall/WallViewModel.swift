//
//  WallViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 14/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import Firebase
class WallViewModel {
    let db = Firestore.firestore()
    var delegate: WallViewController?
    var posts = [Post]()
    var usersImages: [String: UIImage] = [String: UIImage]()
    func loadPosts() {
        db
            .collection(Constants.FStore.posts)
            .addSnapshotListener { (querySnapshot, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    self.posts = []
                    if let snapshotDocuments = querySnapshot?.documents {
                        for i in snapshotDocuments {
                            let data = i.data()
                            let post = Post(id: data["id"] as! String,
                                            title: data["title"] as! String,
                                            owner: data["owner"] as! String,
                                            content: data["content"] as! String,
                                            createTimestamp: "\(data["createTimestamp"] ?? "")",
                                lastCommentTimestamp: "\(data["lastCommentTimestamp"] ?? "")",
                                            comments: [])
                            if self.usersImages[post.owner] == nil {
                                FirebaseManager.shared.getProfilePictureData(for: post.owner) { (data, error) in
                                    if error != nil {
                                        print(error!.localizedDescription )
                                        return
                                    }
                                    self.usersImages[post.owner] = UIImage(data: data!)
                                    self.delegate!.tableView.reloadData()
                                }
                            }
                            self.posts.insert(post, at: 0)
                        }
                        
                    }
                    self.delegate!.tableView.reloadData()
                }
        }
    }
    
}
