//
//  Message.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class MessageBundle {
    var firstUser: String?
    var secondUser: String?
    var messageges: [MessageModel]?
    var lastMessage: String?
    var timestamp: String?
    var profilePicture: UIImage?
}

struct MessageModel {
    var message: String?
    var sender: String?
    var timestamp: String?
}
