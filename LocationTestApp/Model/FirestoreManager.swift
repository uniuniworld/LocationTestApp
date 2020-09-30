//
//  FirestoreManager.swift
//  LocationTestApp
//
//  Created by Takahiro Kirifu on 2020/09/30.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//


import FirebaseCore
import FirebaseFirestore

class FirestoreManager {
    
    let firestore = Firestore.firestore()
    
    func snapshotSelect() {
        
        firestore.collection("")
        
        
    }
    
    
//    var ref: DocumentReference? = nil
//    ref = db.collection("users").addDocument(data: [
//        "first": "Ada",
//        "last": "Lovelace",
//        "born": 1815
//    ]) { err in
//        if let err = err {
//            print("Error adding document: \(err)")
//        } else {
//            print("Document added with ID: \(ref!.documentID)")
//        }
//    }
    
    
}
