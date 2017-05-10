//
//  TaskGroupUser.swift
//  Nudge
//
//  Created by Dephanie Ho on 5/9/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class TaskGroupUser: PFObject {
    @NSManaged var taskGroupUsers: [Pair]?
}
