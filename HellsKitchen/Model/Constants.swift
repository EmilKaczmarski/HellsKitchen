//
//  Constants.swift
//  HellsKitchen
//
//  Created by Apple on 12/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation

struct Constants {
    
    static var currentUserName = ""
    static var currentUserEmail = ""
    
    struct Segues {
        static let registerSegue = "registerSegue"
        static let loginSegue = "loginSegue"
        static let chatUsersSegue = "chatUsersSegue"
        static let wallDetailSegue = "wallDetailSegue"
    }
    
    struct FStore {
        static let allUsers = "allUsers"
        static let allMessages = "messages"
        static let posts = "posts"
        static let messages = "messages"
        
        struct MessageComponents {
            static let message = "message"
            static let sender = "sender"
            static let timestamp = "timestamp"
        }
        
        struct MessageDocumentComponents {
            static let firstUser =  "firstUser"
            static let secondUser = "secondUser"
            static let timestamp = "timestamp"
        }
        
        struct PostComponents {
            static let id = "id"
            static let title = "title"
            static let owner = "owner"
            static let content = "content"
            static let createTimestamp = "createTimestamp"
            static let lastCommentTimestamp = "lastCommentTimestamp"
            static let comments = "comments"
        }
        
    }
    
    
}
