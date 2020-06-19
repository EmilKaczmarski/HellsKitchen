//
//  Message.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class MessageBundle {
    var firstUserEmail: String?
    var secondUserEmail: String?
    var firstUserName: String?
    var secondUserName: String?
    var messageges: [MessageModel]?
    var lastMessage: String?
    var timestamp: String?
    var profilePicture: UIImage?
}

struct MessageModel {
    var message: String?
    var senderEmail: String?
    var timestamp: String?
}
