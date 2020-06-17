//
//  ChangeViewModel.swift
//  HellsKitchen
//
//  Created by Aleksandra Brzostek on 6/17/20.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import Firebase

class ChangeViewModel {
    var delegate: ProfileSettingsViewController?
    let db = Firestore.firestore()
    
    func changeUsername(_ nickname: String, changeUsernameTextField: String?, completion: @escaping (Bool) -> ()) {
        
        if nickname.contains(" ") || nickname.count == 0 || nickname.contains("@") {
            AlertManager.shared.wrongUsernameAlert(in: delegate!)
            completion(false)
            return
        }
        FirebaseManager.shared.checkWhetherUserExists(with: nickname) { (doesExist) in
            if !doesExist {
                if let nickname = changeUsernameTextField {
                    FirebaseManager.shared.changeUser(username: nickname) { success in
                        if success {
                            completion(true)
                        } else {
                            AlertManager.shared.notUniqueUsernameAlert(in: self.delegate!)
                            completion(false)
                        }
                    }
                }
            }
            
        }
        
    }
}
