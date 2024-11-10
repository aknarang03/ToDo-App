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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture) // dismisses keyboard when you tap off of it
        toDoItemContent.layer.cornerRadius = 10
        toDoItemContent.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var toDoItemContent: UITextView!
    
    func timeInterval() -> String {
        let timeNow = Date()
        var timeStr = String(timeNow.timeIntervalSince1970)
        timeStr = timeStr.replacingOccurrences(of: ".", with: "")
        return timeStr
    }
    
    // to be used for ID
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
        let postedBy = userModel.currentUser!.uid
    
        let newItem = ToDo(todoID: id, taskDescription: itemDesc, addedBy: postedBy, addedDateTime: postedTime, completedBy: "N/A", completedDateTime: "N/A")
        
        todoModel.postNewItem(item: newItem) // add item to database
        
        dismissKeyboard()
        
        // let user know that item was added
        let alert = UIAlertController(title: "Add Item",
                                      message: "Item added",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        
        toDoItemContent.text = "" // clear the text in case they want to add more
        
    }

}
