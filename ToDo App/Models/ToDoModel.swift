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
    var msgObserverHandle: UInt?
    
    let todoDBRef = Database.database().reference(withPath: "ToDo")
    
    var postedItems:[ToDo] = []
    
    // watch for updates from ToDo realtime database table
    func observeItems() {
        msgObserverHandle = todoDBRef.observe(.value, with: {snapshot in // listen for value related events
            var tempItems:[ToDo] = []
            for child in snapshot.children { // loop thru the data snapshot (current state of database table)
                if let data = child as? DataSnapshot { // create a snapshot for each child
                    if let item = ToDo(snapshot: data) { // create ToDo from child snapshot
                        tempItems.append(item)
                    }
                }
            }
            self.postedItems.removeAll()
            self.postedItems = tempItems // update the list stored in this model
            NotificationCenter.default.post(name: self.todoNotification, object: nil)
        })
    }
    
    // stop listening for updates
    func cancelObserver() {
        if let observerHandle = msgObserverHandle {
            todoDBRef.removeObserver(withHandle: observerHandle)
        }
    }
    
    // get ToDo item based on item id using this model's saved data
    func getItem(id: String) -> ToDo? {
        return postedItems.first { $0.todoID == id }
    }
    
    // post a new item to ToDo database table
    func postNewItem(item: ToDo) {
        let todoDBRef = Database.database().reference(withPath: "ToDo")
        let newItemRef = todoDBRef.child(item.todoID)
        newItemRef.setValue(item.toAnyObject())
    }
    
    // update an item (works the same way; just replaces old item under same ID)
    func updateItem(item: ToDo) {
        let todoDBRef = Database.database().reference(withPath: "ToDo")
        let newItemRef = todoDBRef.child(item.todoID)
        newItemRef.setValue(item.toAnyObject())
    }
    
    // remove an item from ToDo database table
    func deleteItem(item: ToDo) {
        let todoDBRef = Database.database().reference(withPath: "ToDo")
        let newItemRef = todoDBRef.child(item.todoID)
        newItemRef.removeValue()
    }
    
}
