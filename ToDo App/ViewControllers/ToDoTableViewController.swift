//
//  ToDoTableViewController.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/4/24.
//

import UIKit

class ToDoTableViewController: UITableViewController {

    let todoNotification = Notification.Name(rawValue: todoNotificationKey)
    let todoModel = ToDoModel.shared
    
    var selectedItemId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createObservers()
        todoModel.observeItems()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        todoModel.cancelObserver()
        NotificationCenter.default.removeObserver(self)
    }

    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable(notification:)), name: todoNotification, object: nil)
    }
    
    @objc
    func refreshTable(notification: NSNotification) {
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoModel.postedItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ToDoTableViewCell
        let currentItem = todoModel.postedItems[todoModel.postedItems.count - (indexPath.row+1)]
        cell.taskDescriptionText?.text = currentItem.taskDescription
        cell.addedText?.text = "added by \(currentItem.addedBy) on \(currentItem.addedDateTime)"
        cell.completedText?.text = "completed by \(currentItem.completedBy) on \(currentItem.completedDateTime)"
        if (currentItem.completedBy == "N/A") {cell.checkmark.isHidden = true; cell.completedText.isHidden = true}
        else {cell.checkmark.isHidden = false; cell.completedText.isHidden = false}
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItemId = todoModel.postedItems[todoModel.postedItems.count - (indexPath.row+1)].todoID
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "editSegue") {
            let destinationViewController = segue.destination as! EditItemViewController
            destinationViewController.showItemId = selectedItemId
        }
        
    }

}
