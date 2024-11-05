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
        cell.taskDescriptionText?.text = todoModel.postedItems[todoModel.postedItems.count - (indexPath.row+1)].taskDescription
        cell.addedText?.text = "added by \(todoModel.postedItems[todoModel.postedItems.count - (indexPath.row+1)].addedBy) on \(todoModel.postedItems[todoModel.postedItems.count - (indexPath.row+1)].addedDateTime)"
        cell.completedText?.text = "completed by \(todoModel.postedItems[todoModel.postedItems.count - (indexPath.row+1)].completedBy) on \(todoModel.postedItems[todoModel.postedItems.count - (indexPath.row+1)].completedDateTime)"
        return cell
    }
    

}
