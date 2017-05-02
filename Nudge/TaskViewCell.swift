//
//  TaskViewCell.swift
//  Nudge
//
//  Created by Thuan Nguyen on 4/16/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit

class TaskViewCell: UITableViewCell {
    @IBOutlet weak var tasknameLabel: UILabel!
    @IBOutlet weak var taskdescriptionLabel: UILabel!

    var task: Task!{
        didSet{
            tasknameLabel.text = task.title
            taskdescriptionLabel.text = task.detail
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
