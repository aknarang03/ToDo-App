//
//  ToDoModel.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/4/24.
//

import Foundation
import Firebase
import FirebaseDatabase


class ToDoModel {
    
    static let shared  = ToDoModel()
    
    let todoNotification = Notification.Name(rawValue: todoNotificationKey)
    
    let todoDBRef = Database.database().reference(withPath: "ToDo")
    var msgObserverHandle: UInt?
    
    var postedItems:[ToDo] = []
    
    func observeItems() {
        
        msgObserverHandle = todoDBRef.observe(.value, with: {snapshot in
            var tempItems:[ToDo] = []
            for child in snapshot.children  {
                if let data = child as? DataSnapshot {
                    if let item = ToDo(snapshot: data) {
                        print (item)
                        tempItems.append(item)
                    }
                   
                }
            }
            self.postedItems.removeAll()
            self.postedItems = tempItems
            NotificationCenter.default.post(name: self.todoNotification, object: nil)
        })
    }
    
    func cancelObserver() {
        if let observerHandle = msgObserverHandle {
            todoDBRef.removeObserver(withHandle: observerHandle)
        }
    }
    
    func getItem(id: String) -> ToDo? {
        return postedItems.first { $0.todoID == id }
    }
    
//    func getItem(id: String) async throws -> ToDo {
//        do {
//            let todoDBRef = Database.database().reference()
//            let todoData = try await todoDBRef.child("ToDo/\(id)").getData()
//            if todoData.exists(), let item = ToDo(snapshot: todoData) {
//                return item
//            }
//        } catch {
//            print ("Cannot get item")
//        }
//        return ToDo(todoID:"N/A",taskDescription:"N/A",addedBy:"N/A",addedDateTime: "N/A",completedBy:"N/A",completedDateTime:"N/A")
//    }

    
    func postNewItem(item: ToDo) {
        let todoDBRef = Database.database().reference(withPath: "ToDo")
        let newItemRef = todoDBRef.child(item.todoID)
        newItemRef.setValue(item.toAnyObject())
    }
    
    func updateItem(item: ToDo) {
        let todoDBRef = Database.database().reference(withPath: "ToDo")
        let newItemRef = todoDBRef.child(item.todoID)
        newItemRef.setValue(item.toAnyObject())
    }
    
    func deleteItem(item: ToDo) {
        let todoDBRef = Database.database().reference(withPath: "ToDo")
        let newItemRef = todoDBRef.child(item.todoID)
        newItemRef.removeValue()
    }
    
}

