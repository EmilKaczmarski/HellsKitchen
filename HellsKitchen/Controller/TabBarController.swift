//
//  TabBarController.swift
//  HellsKitchen
//
//  Created by Apple on 02/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.selectedIndex = 0
        if Constants.currentUserName == "" {
            print(item.title!)
            if item.title! == "Chat" {
                self.selectedIndex = 0
            }
        }
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tabBarController.selectedIndex = 0
    }    
}
