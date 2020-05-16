//
//  ShowSplashScreen.swift
//  HellsKitchen
//
//  Created by Aleksandra Brzostek on 5/16/20.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class ShowSplashScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
            self.performSegue(withIdentifier: "showSplashScreen", sender: self)
            }
            
    }
}
