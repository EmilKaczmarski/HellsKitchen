//
//  ProfileSettingsViewController.swift
//  HellsKitchen
//
//  Created by Apple on 17/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class ProfileSettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func removeAccountButtonPressed(_ sender: UIButton) {
        FirebaseManager.shared.removeAccount {
            
        }
        navigationController?.popViewController(animated: true)
    }
    
    
}
