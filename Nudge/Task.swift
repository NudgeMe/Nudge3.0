//
//  Task.swift
//  Nudge
//
//  Created by Dephanie Ho on 4/30/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class Task: PFObject, PFSubclassing {
    
    public static func parseClassName() -> String {
        return "Task"
    }
    
    /* Member variables */
    //Title of the task
    @NSManaged var title: String?
    //Description of the task
    @NSManaged var detail: String?
    //If task is active or "deleted" from the task array
    @NSManaged var isActive: Bool
    //Due date of the task
    @NSManaged var dueDate: Date
}
