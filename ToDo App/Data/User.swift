//
//  User.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/2/24.
//

import Foundation

import Foundation
import Firebase
import FirebaseDatabase

struct User {

    let ref: DatabaseReference?
    let uid: String
    let email: String
    let profileName: String
    let phoneNumber: String
    
    init(uid: String, profileName: String, email: String, phoneNumber: String) {
        self.ref = nil
        self.uid = uid
        self.profileName = profileName
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
    init?(snapshot: DataSnapshot) {
        
        print (snapshot)
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let profileName = value["profileName"] as? String,
            let email = value["email"] as? String,
            let uid = value["uid"] as? String,
            let phoneNumber = value["phoneNumber"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.uid = uid
        self.profileName = profileName
        self.email = email
        self.phoneNumber = phoneNumber
        
    }
    
    func toAnyObject() -> Dictionary<String, String> {
        
        return [
            "profileName": profileName,
            "email": email,
            "uid": uid,
            "phoneNumber": phoneNumber
        ]
        
    }
    
}