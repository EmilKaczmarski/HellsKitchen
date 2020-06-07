//
//  ChatNavigationController.swift
//  HellsKitchen
//
//  Created by Apple on 08/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation

class ChatNavigationController: ProtectedDataNavigationController {
   override var segueName: String? { get { return Constants.Segues.chatNavigationSegue } }
}
