//
//  ItemDetailsViewController.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/7/24.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    
    var showItemId: String?
    var selectedItem: ToDo?
    let toDoModel = ToDoModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var todoDescription: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let itemId = showItemId {
            
            selectedItem = toDoModel.getItem(id: itemId)
            
            if (selectedItem != nil) {
                
                todoDescription.text = selectedItem?.taskDescription
                
            }
            
        }
        
    }

}
