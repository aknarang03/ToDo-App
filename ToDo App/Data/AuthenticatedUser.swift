//
//  AuthenticatedUser.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/2/24.
//

import Foundation
import FirebaseAuth

struct AuthenticatedUser {
  
    let uid: String
    let email: String
  
    init(authData: FirebaseAuth.User) {
        uid = authData.uid
        email = authData.email!
    }
  
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}