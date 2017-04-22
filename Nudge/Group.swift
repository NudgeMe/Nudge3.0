//
//  Group.swift
//  Nudge
//
//  Created by Thuan Nguyen on 4/22/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse
class Group: NSObject {
    
    class func newGroup(groupName: String?,user: PFUser, withCompletion completion: @escaping PFBooleanResultBlock){
        user.addUniqueObject("", forKey: "Group")
    
    }
    
    
    
    

}
