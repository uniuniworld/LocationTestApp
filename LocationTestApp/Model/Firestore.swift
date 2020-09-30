//
//  Firestore.swift
//  LocationTestApp
//
//  Created by Takahiro Kirifu on 2020/09/30.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit

import FirebaseCore
import FirebaseFirestore

public class Firestore {
    
    var db: Firestore!
    
    override init() {
        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
}
