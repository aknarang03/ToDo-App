//
//  AddItemViewController.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/7/24.
//

import UIKit

class AddItemViewController: UIViewController {
    
    let userModel = UserModel.shared
    let todoModel = ToDoModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print (userModel.currentUser)
    }
    
    @IBOutlet weak var toDoItemContent: UITextView!
    
    func timeInterval() -> String {
        let tnow = Date()
        var ts = String(tnow.timeIntervalSince1970)
        ts = ts.replacingOccurrences(of: ".", with: "")
        return ts
    }
    
    func getLongDateTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        return dateFormatter.string(from: date)
    }
    
    @IBAction func addItemPressed(_ sender: Any) {
        
        guard let itemDesc = toDoItemContent.text else { return }
        let id = timeInterval()
        let postedTime = getLongDateTime()
        let postedBy = userModel.currentUser!.username
    
        let newItem = ToDo(todoID: id, taskDescription: itemDesc, addedBy: postedBy, addedDateTime: postedTime, completedBy: "N/A", completedDateTime: "N/A")
        
        todoModel.postNewItem(item: newItem)
        
    }

}
