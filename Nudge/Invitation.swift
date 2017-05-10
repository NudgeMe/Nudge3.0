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
    //User Id of the sender
    @NSManaged var senderId: String?
    
    //User name of the sender
    @NSManaged var senderName: String!
    
    //Full name of the sender
    @NSManaged var senderFullName: String!
    
    //User Id of the receipient
    @NSManaged var receipientId: String?
    
    //Invitation message
    @NSManaged var message: String!
    
    //Group Id to invite receipient to
    @NSManaged var groupId: String?
    
    //Group name of the group Id
    @NSManaged var groupName: String!
    
    //Status of the invitation - created, accepted, declined
    @NSManaged var status: Int
    
    //Date the invitation was created
    @NSManaged var dateCreated: String?
}
