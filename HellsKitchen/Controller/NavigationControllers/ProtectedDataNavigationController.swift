//
//  ProtectedDataNavigationController.swift
//  HellsKitchen
//
//  Created by Apple on 08/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
class ProtectedDataNavigationController: UINavigationController {
    var segueName: String? { get { return nil } }
    var upperLabelForChildController: String? { get { return nil} }
    var lowerLabelForChildController: String? { get { return nil} }
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewWillAppear(false)
        if Constants.currentUserName == "" {
            if let name = segueName {
                self.performSegue(withIdentifier: name, sender: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if !(UIApplication.getTopViewController() is SignInMenuViewController) {
                        self.performSegue(withIdentifier: name, sender: self)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if Constants.currentUserName == "" {
            if let name = segueName {
                self.performSegue(withIdentifier: name, sender: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if !(UIApplication.getTopViewController() is SignInMenuViewController) {
                        self.performSegue(withIdentifier: name, sender: self)
                    }
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SignInMenuViewController
        Constants.isAuthorisationAlert = false
        if let upperTitle = upperLabelForChildController {
            vc.upperTitle = upperTitle
        }
        
        if let lowerTitle = lowerLabelForChildController {
            vc.lowerTitle = lowerTitle
        }
    }
}
