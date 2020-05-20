//
//  FirebaseManagement.swift
//  HellsKitchen
//
//  Created by Apple on 20/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseManagementProtocol {
    func setupDatabase(db: Firestore)
}

extension FirebaseManagementProtocol {
    func enableOffline() {
        // [START enable_offline]
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true

        // Any additional options
        // ...
        // Enable offline data persistence
        let db = Firestore.firestore()
        db.settings = settings
        // [END enable_offline]
    }
}
