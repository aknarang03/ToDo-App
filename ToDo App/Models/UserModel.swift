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
    let onlineUsersUpdatedNotification = Notification.Name(rawValue: onlineUsersListUpdatedKey)
    
    var authorizedUser: AuthenticatedUser?
    var currentUser: User?
    
    var users:[User] = []
    var onlineUsers: [String] = []
    
    private init() {}
    
    func signInAsync (withEmail email: String, andPassword pw: String) async throws -> (Bool, String) {
        
        do {
            let authData = try await Auth.auth().signIn(withEmail: email, password: pw)
            authorizedUser = AuthenticatedUser(uid: authData.user.uid, email: authData.user.email!)
            try await getLoggedInUser()
            return (true, "Signin Successful")
        }
        
        catch {
            let e = error
            return (false, e.localizedDescription)
        }
        
    }
    
    func signOut() {
        do {
            offLineUser(uid: currentUser!.uid)
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func registerAsync (withEmail email: String, password pw: String, andProfileName name: String, andPhoneNumber phone: String) async throws -> (Bool, String) {
        do {
            let userCreateResponse = try await Auth.auth().createUser(withEmail: email, password: pw)
            authorizedUser = AuthenticatedUser(uid: userCreateResponse.user.uid, email: userCreateResponse.user.email!)
            newRegisteredUser(withUid: authorizedUser!.uid, profileName: name, andEmail: email, phoneNumber: phone)
            return (true, "User info Registered")
        }
        catch {
            let e = error
            return (false, e.localizedDescription)
        }
    }

    func newRegisteredUser(withUid uid: String, profileName name: String, andEmail email: String, phoneNumber phone: String) {
        
        let userDBref = Database.database().reference(withPath: "Users")
        let user = User(uid: uid, profileName: name, email: email, phoneNumber: phone)
        let userNodeRef = userDBref.child(user.uid)
        
        userNodeRef.setValue(user.toAnyObject())
    }
    
    func onlineUser (uid: String, profileName name: String) {
        let onlineDBref = Database.database().reference(withPath: "Online")
        let ref = onlineDBref.child(uid)
        ref.setValue(name)
    }
    
    func offLineUser(uid: String) {
        let onlineDBref = Database.database().reference(withPath: "Online")
        let ref = onlineDBref.child(uid)
        ref.removeValue()
    }

    func listRegisteredUsers() async throws   {
        let userDBref = Database.database().reference(withPath: "Users")
        
        // var regUsers:[User] = []
        users.removeAll()
        
        do {
            let snapshot = try await userDBref.getData()
            for child in snapshot.children {
                if let userData = child as? DataSnapshot {
                    let anUser = User(snapshot: userData)
                    users.append(anUser!)
                    
                }
                
            }
        } catch {
            print ("can not get users")
        }
        
        // return regUsers
        
    }

    
    func observeUsers () {
        let userDBref = Database.database().reference(withPath: "Users")
        
        userDBref.observe(.value, with: {snapshot in
            var tempUsers:[User] = []
            for child in snapshot.children  {
                if let data = child as? DataSnapshot {
                    if let anUser = User(snapshot: data) {
                        
                        tempUsers.append(anUser)
                    }
                    
                }
            }
            self.users.removeAll()
            self.users = tempUsers
            
            NotificationCenter.default.post(name: self.usersUpdatedNotification, object: nil)
        })
        
    }

    func getLoggedInUserOnce () {
        let userDBref = Database.database().reference(withPath: "Users").child(authorizedUser!.uid)
        
        userDBref.observeSingleEvent (of: .value, with: {snapshot in
            if let data = snapshot.value as? DataSnapshot {
                self.currentUser = User(snapshot: data)
            }
        })
    }
    
    func getLoggedInUser() async throws {
        do {
            if let uid = authorizedUser?.uid {
                let userDBref = Database.database().reference()
                
                let userData = try await userDBref.child("Users/\(uid)").getData()
                // print ("we have data snapshot")
                // print (userData)
                currentUser = User(snapshot: userData)
                onlineUser(uid: currentUser!.uid, profileName: currentUser!.profileName)
                // print (currentUser)
            }
            
        } catch {
            print ("can not get users")
        }
        
    }
    
    func observeOnlineUsers () {
        let userDBref = Database.database().reference(withPath: "Online")
        print ("*** online ***")
        userDBref.observe(.value, with: {snapshot in
                var tempOnlineUsers:[String] = []
                for child in snapshot.children  {
                    if let data = child as? DataSnapshot {
                        let name = data.value as? String
                        tempOnlineUsers.append(name!)
                    }
                }
                self.onlineUsers.removeAll()
                self.onlineUsers = tempOnlineUsers
            
            NotificationCenter.default.post(name: self.onlineUsersUpdatedNotification, object: nil)
                
            })
        }
}
