//
//  ToDoTableViewController.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/4/24.
//

import UIKit

class ToDoTableViewController: UITableViewController {

    let todoNotification = Notification.Name(rawValue: todoNotificationKey)
    let userNotification = Notification.Name(rawValue: usersNotificationKey)
    let todoModel = ToDoModel.shared
    let userModel = UserModel.shared
    
    var selectedItemId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createObservers()
        todoModel.observeItems()
        userModel.observeUsers() // observe users so that usernames can be displayed
        
        /* I made it so that ToDo items have a user ID attached instead of a username, so users should probably
        be observed in case a new user posts something... */
    }
    
    // stop observing when you can't see the table
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        todoModel.cancelObserver()
        userModel.cancelObserver()
        NotificationCenter.default.removeObserver(self, name: todoNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: userNotification, object: nil)
    }

    // wait for notifications
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable(notification:)), name: todoNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable(notification:)), name: userNotification, object: nil)
    }
    
    // refresh the table when user or todo notification is recieved
    @objc func refreshTable(notification: NSNotification) {
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoModel.postedItems.count
    }
    
    // make the date string smaller for display purposes
    func formatDateString(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MMMM d, yyyy 'at' h:mm:ss a zzz"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "M/d/yyyy h:mm a zzz"
            return outputFormatter.string(from: date)
        }
        return nil
    }

    @IBAction func logoutPressed(_ sender: Any) {
        userModel.signOut()
        self.dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ToDoTableViewCell
        let currentItem = todoModel.postedItems[todoModel.postedItems.count - (indexPath.row+1)]
        
        cell.taskDescriptionText?.text = currentItem.taskDescription
        
        cell.addedText?.text = "added by \(userModel.getUsername(for: currentItem.addedBy) ?? "") on \(formatDateString(currentItem.addedDateTime) ?? "")"
        
        cell.completedText?.text = "completed by \(userModel.getUsername(for: currentItem.completedBy) ?? "") on \(formatDateString(currentItem.completedDateTime) ?? "")"
        
        // show as complete or incomplete
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
