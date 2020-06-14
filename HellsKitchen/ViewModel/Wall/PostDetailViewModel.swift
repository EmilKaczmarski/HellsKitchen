//
//  PostDetailViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 14/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import Firebase
class PostDetailViewModel {
    let db = Firestore.firestore()
    var delegate: CreatePostViewController?

    func savePost(_ post: Post) {
        db
            .collection(Constants.FStore.posts)
            .addDocument(data: [
                Constants.FStore.PostComponents.id : post.id,
                Constants.FStore.PostComponents.content : post.content,
                Constants.FStore.PostComponents.createTimestamp : post.createTimestamp,
                Constants.FStore.PostComponents.owner : post.owner,
                Constants.FStore.PostComponents.title : post.title
            ])
    }
}

