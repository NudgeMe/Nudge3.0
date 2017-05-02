//
//  TaskGroup.swift
//  Nudge
//
//  Created by Dephanie Ho on 4/22/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class TaskGroup: PFObject, PFSubclassing {
    /**
     The name of the class as seen in the REST API.
     */
    public static func parseClassName() -> String {
        return "TaskGroup"
    }
    
    /* Member variables */
    //Array of tasks
    @NSManaged var tasks: [Task]?
    //Name of the group
    @NSManaged var name: String?
}
