//
//  UserModel.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/2/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserModel {
    
    static let shared = UserModel()
    
    let usersUpdatedNotification = Notification.Name(rawValue: usersListUpdatedKey)
    
    let userDBref = Database.database().reference(withPath: "Users")
    
    var authorizedUser: AuthenticatedUser?
    var currentUser: User?
    
    var users:[User] = []
    
    private init() {}
    
    func signInAsync (withEmail email: String, andPassword pw: String) async throws -> (Bool, String) {
        do {
            let authData = try await Auth.auth().signIn(withEmail: email, password: pw)
            authorizedUser = AuthenticatedUser(uid: authData.user.uid, email: authData.user.email!)
            try await getLoggedInUser()
            return (true, "Login successful")
        }
        catch {
            let e = error
            return (false, e.localizedDescription)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    func registerAsync (withEmail email: String, password pw: String, andUsername name: String) async throws -> (Bool, String) {
        do {
            let userCreateResponse = try await Auth.auth().createUser(withEmail: email, password: pw)
            authorizedUser = AuthenticatedUser(uid: userCreateResponse.user.uid, email: userCreateResponse.user.email!)
            newRegisteredUser(withUid: authorizedUser!.uid, username: name, andEmail: email)
            return (true, "User registered")
        }
        catch {
            let e = error
            return (false, e.localizedDescription)
        }
    }

    func newRegisteredUser(withUid uid: String, username name: String, andEmail email: String) {
        let user = User(uid: uid, username: name, email: email)
        let userNodeRef = userDBref.child(user.uid)
        userNodeRef.setValue(user.toAnyObject())
    }

    func observeUsers () {
        userDBref.observe(.value, with: {snapshot in
            var tempUsers:[User] = []
            for child in snapshot.children  {
                if let data = child as? DataSnapshot {
                    if let tempUser = User(snapshot: data) {
                        tempUsers.append(tempUser)
                    }
                }
            }
            self.users.removeAll()
            self.users = tempUsers
            NotificationCenter.default.post(name: self.usersUpdatedNotification, object: nil)
        })
    }
    
    func getLoggedInUser() async throws {
        do {
            if let uid = authorizedUser?.uid {
                let userDBref = Database.database().reference()
                let userData = try await userDBref.child("Users/\(uid)").getData()
                currentUser = User(snapshot: userData)
            }
            
        } catch {
            print ("Cannot get logged in user")
        }
    }
    
}
