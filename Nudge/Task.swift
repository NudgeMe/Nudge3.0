//
//  Task.swift
//  Nudge
//
//  Created by Lin Zhou on 4/17/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class Task: NSObject {
    var title: String?
    var taskDescription: String?
    
    /** Method to add a task to Parse */
    class func createTask(taskTitle: String?, taskDescription: String?){
        let task = PFObject(className: "Task")
        
        task["title"] = taskTitle
        task["description"] = taskDescription
        
        task.saveInBackground()

}
}
