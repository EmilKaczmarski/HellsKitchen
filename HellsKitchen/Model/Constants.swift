//
//  Constants.swift
//  HellsKitchen
//
//  Created by Apple on 12/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
//MARK: - User Variables
struct Constants {
    static var currentUserName = ""
    static var currentUserEmail = ""
    static var hasDefaultImage: Bool?
    static var currentUserProfilePicture = UIImage(named: "defaultProfilePicture")
    static var externalRegisterProfilePicture: UIImage?
    static let usernameKey = "username"
    static let signInIndicator = ""
    
}

//MARK: -Fonts
extension Constants {
    struct Fonts {
        static let arialRounded = "Arial Rounded MT Bold"
    }
}
//MARK: - Colors
extension Constants {
    struct Colors {
        static let green = "#A8E6CF"
        static let lightGreen = "#DCEDC1"
        
        static let orange = "#FFD3B6"
        static let red = "#FFAAA5"
        static let deepRed = "#C4352B"
        static let lightYellow = "#EDEBC1"
        
        static let deepGreen = UIColor(displayP3Red: 1.0/255.0, green: 80.0/255.0, blue: 103.0/255.0, alpha: 1.0)
        static let deepGreenDisabled = UIColor(displayP3Red: 1.0/255.0, green: 80.0/255.0, blue: 103.0/255.0, alpha: 0.5)
        static let lightBlue = UIColor(displayP3Red: 250.0/255.0, green: 252.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        static let ice = UIColor(displayP3Red: 250.0/255.0, green: 252.0/255.0, blue: 251.0/251.0, alpha: 1.0)
        static let lightGray = UIColor(displayP3Red: 204.0/255.0, green: 210.0/255.0, blue: 211.0/251.0, alpha: 1.0)
    }
}

//MARK: - Segues
extension Constants {
    struct Segues {
        static let wallLoginSegue = "wallLoginSegue"
        static let registerSegue = "registerSegue"
        static let loginSegue = "loginSegue"
        static let chatUsersSegue = "chatUsersSegue"
        static let wallDetailSegue = "wallDetailSegue"
        static let recipesSegue = "recipesSegue"
        static let provideSegue = "recipesSegue"
        static let recipeCategorySegue = "recipeCategorySegue"
        
        static let addPostNavigationSegue = "addPostNavigationSegue"
        static let profileNavigationSegue = "profileNavigationSegue"
        static let chatNavigationSegue = "chatNavigationSegue"
    }
}

//MARK: - Firebase
extension Constants {
    struct FStore {
        static let allUsers = "allUsers"
        static let allMessages = "messages"
        static let posts = "posts"
        static let messages = "messages"
        
        struct MessageComponents {
            static let message = "message"
            static let senderEmail = "senderEmail"
            static let timestamp = "timestamp"
        }
        
        struct MessageDocumentComponents {
            static let firstUserEmail =  "firstUserEmail"
            static let secondUserEmail = "secondUserEmail"
            static let firstUserName =  "firstUserName"
            static let secondUserName = "secondUserName"
            static let timestamp = "timestamp"
            static let lastMessage = "lastMessage"
        }
        
        struct UserComponents {
            static let username = "username"
            static let email = "email"
            static let hasDefaultImage = "hasDefaultImage"
        }
        
        struct PostComponents {
            static let id = "id"
            static let title = "title"
            static let ownerName = "ownerName"
            static let ownerEmail = "ownerEmail"
            static let content = "content"
            static let cooking = "cooking"
            static let calories = "calories"
            static let createTimestamp = "createTimestamp"
            static let lastCommentTimestamp = "lastCommentTimestamp"
            static let comments = "comments"
        }
    }
}

//MARK: - Sizes
extension Constants {
    struct Sizes {
        static let chatViewCellHeight = 70.0
        static let avatarSize = 50.0
    }
}

//MARK: - Funcitons
extension Constants {
    struct Functions {
        static func getImageWithColorPosition(color: UIColor, size: CGSize, lineSize: CGSize) -> UIImage {
            let rect = CGRect(x:0, y: 0, width: size.width, height: size.height)
            let rectLine = CGRect(x:0, y:size.height-lineSize.height,width: lineSize.width,height: lineSize.height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            UIColor.clear.setFill()
            UIRectFill(rect)
            color.setFill()
            UIRectFill(rectLine)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        }
        
        static func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
            let textColor = UIColor.white
            let textFont = UIFont.systemFont(ofSize: 10.0)
            
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
            
            let textFontAttributes = [
                NSAttributedString.Key.font: textFont,
                NSAttributedString.Key.foregroundColor: textColor,
                ] as [NSAttributedString.Key : Any]
            image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
            
            let rect = CGRect(origin: point, size: image.size)
            text.draw(in: rect, withAttributes: textFontAttributes)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage!
        }
    }
}


//MARK: - pictures


extension Constants {
    struct Pictures {
        static let defaultProfile = UIImage(named: "defaultProfilePicture" )
        static let defaultPost = UIImage(named: "plainWhite")
    }
}
