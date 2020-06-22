//
//  PostDetailViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 14/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import Firebase
class CreatePostViewModel {
    let db = Firestore.firestore()
    var delegate: CreatePostViewController?

    func savePost(_ post: Post) {
        db
            .collection(Constants.FStore.posts)
            .document(post.id)
            .setData([
                Constants.FStore.PostComponents.id : post.id,
                Constants.FStore.PostComponents.content : post.content,
                Constants.FStore.PostComponents.createTimestamp : post.createTimestamp,
                Constants.FStore.PostComponents.ownerName : post.ownerName,
                Constants.FStore.PostComponents.ownerEmail : post.ownerEmail,
                Constants.FStore.PostComponents.title : post.title,
                Constants.FStore.PostComponents.calories : post.calories,
                Constants.FStore.PostComponents.cooking : post.cooking
            ])
        guard let postIngredients = post.ingredients else { return }
        var ingredients = [String: String]()
        for i in 0..<postIngredients.count {
            ingredients["\(i)"] = postIngredients[i]
        }
        db
        .collection(Constants.FStore.posts)
        .document(post.id)
        .collection(Constants.FStore.PostComponents.ingredients)
        .addDocument(data: ingredients)
    }
}

