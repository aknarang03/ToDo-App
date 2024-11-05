//
//  ToDoTableViewCell.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/4/24.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var addedText: UILabel!
    @IBOutlet weak var completedText: UILabel!
    @IBOutlet weak var taskDescriptionText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
