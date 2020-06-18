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
    var postsImages: [String: UIImage] = [String: UIImage]()
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
                                        print(error!.localizedDescription)
                                        return
                                    }
                                    self.usersImages[post.owner] = UIImage(data: data!)
                                    self.delegate!.tableView.reloadData()
                                }
                            }
                            if self.postsImages[post.id] == nil {
                                FirebaseManager.shared.getPostPictureData(for: post.id) { (data, error) in
                                    if error != nil {
                                        self.setPostPicture(for: post)
                                        return
                                    }
                                    self.postsImages[post.id] = UIImage(data: data!)
                                    self.insertPost(post)
                                }
                            } else {
                                self.insertPost(post)
                            }
                        }
                    }
                    
                }
        }
    }
    func setPostPicture(for post: Post) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FirebaseManager.shared.getPostPictureData(for: post.id) { (data, error) in
                if error != nil {
                    return
                }
                self.postsImages[post.id] = UIImage(data: data!)
                self.insertPost(post)
                self.delegate!.tableView.reloadData()
            }
        }
    }
    
    func insertPost(_ post: Post) {
        if doesPostExist(with: post.id) {
            return
        }
        
        if posts.count == 0 {
            posts.insert(post, at: 0)
            delegate!.tableView.reloadData()
            return
        }
        var index = 0
        for i in posts {
            print(i.title)
            print(i.createTimestamp)
            print(post.createTimestamp)
            if i.createTimestamp < post.createTimestamp {
                posts.insert(post, at: index)
                delegate!.tableView.reloadData()
                return
            }
            index += 1
        }
        posts.append(post)
        delegate!.tableView.reloadData()
    }
    
    func doesPostExist(with id: String)-> Bool {
        return posts.contains { (post) -> Bool in
            return post.id == id
        }
    }
}
