//
//  ToDoTableViewCell.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/4/24.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var addedText: UILabel!
    @IBOutlet weak var taskDescriptionText: UITextView!
    @IBOutlet weak var completedText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
