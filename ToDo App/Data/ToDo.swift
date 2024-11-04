//
//  ToDo.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/4/24.
//

import Foundation
import Firebase
import FirebaseDatabase

struct ToDo {
    
    var ref: DatabaseReference?
    var todoID: String
    var taskDescription: String
    var addedBy: String
    var addedDateTime: String
    var completedBy: String
    var completedDateTime: String
        
    init (todoID: String, taskDescription: String, addedBy: String, addedDateTime: String, completedBy: String, completedDateTime: String) {
        self.ref = nil
        self.todoID = todoID
        self.taskDescription = taskDescription
        self.addedBy = addedBy
        self.addedDateTime = addedDateTime
        self.completedBy = completedBy
        self.completedDateTime = completedDateTime
    }
    
    init? (snapshot: DataSnapshot) {
     
        guard
            let value = snapshot.value as? [String: Any],
            let todoID = value["todoID"] as? String,
            let taskDescription = value["taskDescription"] as? String,
            let addedBy = value["addedBy"] as? String,
            let addedDateTime = value["addedDateTime"] as? String,
            let completedBy = value["completedBy"] as? String,
            let completedDateTime = value["completedDateTime"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.todoID = todoID
        self.taskDescription = taskDescription
        self.addedBy = addedBy
        self.addedDateTime = addedDateTime
        self.completedBy = completedBy
        self.completedDateTime = completedDateTime
        
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        return [
            "todoID": self.todoID,
            "taskDescription": self.taskDescription,
            "addedBy": self.addedBy,
            "addedDateTime": self.addedDateTime,
            "completedBy": self.completedBy,
            "completedDateTime": self.completedDateTime
        ]
    }
    
}
