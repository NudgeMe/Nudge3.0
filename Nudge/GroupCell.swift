//
//  GroupCell.swift
//  Nudge
//
//  Created by Lin Zhou on 4/17/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class GroupCell: UITableViewCell {
    
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var member: PFUser!{
        didSet{
            memberLabel.text = "Hello"
            
            
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
