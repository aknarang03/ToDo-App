//
//  ItemDetailsViewController.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/7/24.
//

import UIKit

class EditItemViewController: UIViewController {
    
    var showItemId: String?
    var selectedItem: ToDo?
    let toDoModel = ToDoModel.shared
    let userModel = UserModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var todoDescription: UILabel!
    @IBOutlet weak var completedSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let itemId = showItemId {
            
            selectedItem = toDoModel.getItem(id: itemId)
            
            if (selectedItem != nil) {
                
                todoDescription.text = selectedItem?.taskDescription
                
                if (selectedItem?.completedDateTime == "N/A") {
                    completedSwitch.isOn = false
                } else {
                    completedSwitch.isOn = true
                }
                
            }
            
        }
        
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        
        if let currentUser = userModel.currentUser {

            if (completedSwitch.isOn) {
                selectedItem?.completedBy = currentUser.username
                selectedItem?.completedDateTime = getLongDateTime()
            } else {
                selectedItem?.completedBy = "N/A"
                selectedItem?.completedDateTime = "N/A"
            }
            
        }
    
    }
    
    @IBAction func saveButtonPress(_ sender: Any) {
        if let item = selectedItem {
            toDoModel.updateItem(item: item)
        } else {
            print("Cannot save")
        }
    }
    
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
    
}
