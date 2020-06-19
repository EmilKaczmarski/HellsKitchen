//
//  PostModel.swift
//  HellsKitchen
//
//  Created by Apple on 14/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation

struct Post {
    let id: String
    let title: String
    let ownerName: String
    let ownerEmail: String
    //let photo: UIImage() in further plans
    let content: String
    let cooking: String
    let calories: String
    let createTimestamp: String
    var lastCommentTimestamp: String?
    var comments: [Comment]?
}

struct Comment {
    let comment: String
    let owner: String
}
