//
//  PostModel.swift
//  HellsKitchen
//
//  Created by Apple on 14/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation

class Post {
    var id: String = ""
    var title: String = ""
    var ownerName: String = ""
    var ownerEmail: String = ""
    //varet photo: UIImage() in further plans = ""
    var content: String = ""
    var cooking: String = ""
    var calories: String = ""
    var createTimestamp: String = ""
    var ingredients: [String]?
}

struct Comment {
    let comment: String
    let owner: String
}
