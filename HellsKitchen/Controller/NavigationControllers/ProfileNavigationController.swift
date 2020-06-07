//
//  ProfileNavigationController.swift
//  HellsKitchen
//
//  Created by Apple on 07/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class ProfileNavigationController: ProtectedDataNavigationController {
    override var segueName: String? { get { return Constants.Segues.profileNavigationSegue } }
    override var upperLabelForChildController: String? { get { return "Sign in to see your"} }
    override var lowerLabelForChildController: String? { get { return "profile"} }
}
