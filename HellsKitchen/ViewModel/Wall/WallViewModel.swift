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
                            let post = Post()
                            post.id = data["id"] as! String
                            post.title = data["title"] as! String
                            post.ownerName = data["ownerName"] as! String
                            post.ownerEmail = data["ownerEmail"] as! String
                            post.content = data["content"] as! String
                            post.cooking = data["cooking"] as! String
                            post.calories = data["calories"] as! String
                            post.createTimestamp = "\(data["createTimestamp"] ?? "")"
                            post.ingredients = []
                            self.loadIngredients(for: post)
                            if self.usersImages[post.ownerEmail] == nil {
                                FirebaseManager.shared.getProfilePictureData(for: post.ownerEmail) { (data, error) in
                                    if error != nil {
                                        print(error!.localizedDescription)
                                        return
                                    }
                                    self.usersImages[post.ownerEmail] = UIImage(data: data!)
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
    
    func loadIngredients(for post: Post) {
        db
        .collection(Constants.FStore.posts)
        .document(post.id)
        .collection(Constants.FStore.PostComponents.ingredients)
            .getDocuments { (querySnapschot, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapschot?.documents {
                        guard let allIngredients = snapshotDocuments.first else { return }
                        for (ingredient) in allIngredients.data() {
                            post.ingredients!.append(ingredient.value as! String)
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
            //setNewUsernameIfIsIncorrect(for: post) {
            //    self.delegate?.tableView.reloadData()
            return
            //}
        }
        
        if posts.count == 0 {
            posts.insert(post, at: 0)
            delegate!.tableView.reloadData()
            
            return
        }
        var index = 0
        for i in posts {
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
    
    func setNewUsernameIfIsIncorrect(for post: Post, completion: @escaping ()-> ()) {
        FirebaseManager.shared.getUsernameForGivenEmail(post.ownerEmail) { (username) in
            if username == "" {
                completion()
                return
            }
            
            if username == post.ownerName {
                completion()
                return
            }

            let newPost = Post()
            newPost.id = post.id
            newPost.title = post.title
            newPost.ownerName = post.ownerName
            newPost.ownerEmail = post.ownerEmail
            newPost.content = post.content
            newPost.cooking = post.cooking
            newPost.calories = post.calories
            newPost.createTimestamp = post.createTimestamp
            
            self.removePost(post) {
                self.insertPost(newPost)
                completion()
            }
        }
    }
    func removePost(_ post: Post, completion: @escaping ()-> ()) {
        posts.removeAll { (post) -> Bool in
            return post.id == post.id
        }
    }
    
}
