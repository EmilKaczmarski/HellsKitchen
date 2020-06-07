//
//  ProtectedDataNavigationController.swift
//  HellsKitchen
//
//  Created by Apple on 08/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
class ProtectedDataNavigationController: UINavigationController {
    var segueName: String? { get { return nil} }
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewWillAppear(false)
        if Constants.currentUserName == "" {
            if let name = segueName {
                performSegue(withIdentifier: name, sender: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        print(Constants.currentUserName)
        if let name = segueName {
            performSegue(withIdentifier: name, sender: self)
        }
    }
}
