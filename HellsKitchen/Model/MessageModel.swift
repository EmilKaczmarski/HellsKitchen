//
//  Message.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation

struct MessageBundle {
    var firstUser: String?
    var secondUser: String?
    var messageges: [MessageModel]?
    var lastMessage: String?
    var timestamp: String?
}

struct MessageModel {
    var message: String?
    var sender: String?
    var timestamp: String?
}
