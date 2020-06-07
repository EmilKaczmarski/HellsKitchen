//
//  AddPostNavigationController.swift
//  HellsKitchen
//
//  Created by Apple on 07/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class AddPostNavigationController: UINavigationController {
      override func viewDidLoad() {
          super.viewWillAppear(true)
          if Constants.currentUserName == "" {
            performSegue(withIdentifier: Constants.Segues.addPostNavigationSegue, sender: self)
              //tabBarController?.selectedIndex = 4
          }
      }
     
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(false)
          if Constants.currentUserName == "" {
              performSegue(withIdentifier: Constants.Segues.addPostNavigationSegue, sender: self)
              //tabBarController?.selectedIndex = 4
          }
      }
    
}
