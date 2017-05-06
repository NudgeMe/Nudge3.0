//
//  Invitation.swift
//  Nudge
//
//  Created by Dephanie Ho on 5/6/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class Invitation: PFObject, PFSubclassing {
    
    public static func parseClassName() -> String {
        return "Invitation"
    }
    
    /* Member variables */
    @NSManaged var senderId: String?
    @NSManaged var receipientId: String?
    @NSManaged var message: String?
    @NSManaged var groupId: String?
    @NSManaged var status: Int
    @NSManaged var dateCreated: String?
}
