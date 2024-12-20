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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        todoDescription.layer.cornerRadius = 10
        todoDescription.clipsToBounds = true
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @IBOutlet weak var editableLabel: UILabel! // tells user if they can edit the text or not
    @IBOutlet weak var todoDescription: UITextView!
    @IBOutlet weak var completedSwitch: UISwitch!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let itemId = showItemId {
            
            selectedItem = toDoModel.getItem(id: itemId)
            
            if (selectedItem != nil) {
                                
                // indicate text is editable if user ID matches selected item's posted by user ID
                let editable = (selectedItem?.addedBy == userModel.currentUser?.uid)
                
                todoDescription.text = selectedItem?.taskDescription
                
                if (editable) {
                    todoDescription.isEditable = true
                    deleteButton.isHidden = false
                    editableLabel.text = "can edit text"
                } else {
                    todoDescription.isEditable = false
                    deleteButton.isHidden = true
                    editableLabel.text = "cannot edit text"
                }
                
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
                selectedItem?.completedBy = currentUser.uid
                selectedItem?.completedDateTime = getLongDateTime()
            } else {
                selectedItem?.completedBy = "N/A"
                selectedItem?.completedDateTime = "N/A"
            }
            
        }
    
    }
    @IBAction func deleteButtonPress(_ sender: Any) {
        if let item = selectedItem {
            toDoModel.deleteItem(item: item)
            navigationController?.popViewController(animated: true)
        } else {
            print("Cannot delete")
        }
    }
    
    @IBAction func saveButtonPress(_ sender: Any) {
        selectedItem?.taskDescription = todoDescription.text
        if let item = selectedItem {
            toDoModel.updateItem(item: item)
            navigationController?.popViewController(animated: true)
        } else {
            print("Cannot save")
        }
    }
    
    // to be used for IDs
    func getLongDateTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        return dateFormatter.string(from: date)
    }
    
}
