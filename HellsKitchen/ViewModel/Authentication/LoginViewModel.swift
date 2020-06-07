//
//  LoginViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//
import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewModel {
    
    let db = Firestore.firestore()
    var delegate: LoginViewController?
}

extension LoginViewModel {  
}
