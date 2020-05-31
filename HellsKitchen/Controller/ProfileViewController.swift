//
//  ProfileViewController.swift
//  HellsKitchen
//
//  Created by Aleksandra Brzostek on 5/30/20.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var logOutIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.cornerRadius = profilePicture.bounds.width / 2
    }
}
