//
//  NudgeNotifcation.swift
//  Nudge
//
//  Created by Dephanie Ho on 5/6/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class NudgeNotifcation: PFObject, PFSubclassing {
    public static func parseClassName() -> String {
        return "NudgeNotification"
    }
    
    /* Member variables */
    @NSManaged var senderId: String?
    @NSManaged var receipientId: String?
    @NSManaged var message: String?
    @NSManaged var groupId: String?
    @NSManaged var status: Bool
    @NSManaged var dateCreated: String?

}
