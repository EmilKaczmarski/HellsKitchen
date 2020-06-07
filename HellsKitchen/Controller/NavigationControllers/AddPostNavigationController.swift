//
//  AddPostNavigationController.swift
//  HellsKitchen
//
//  Created by Apple on 07/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class AddPostNavigationController: ProtectedDataNavigationController {
    override var segueName: String? { get { return Constants.Segues.addPostNavigationSegue } }
}
