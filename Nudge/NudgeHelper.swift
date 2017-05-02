//
//  NudgeHelper.swift
//  Nudge
//
//  Created by Dephanie Ho on 4/30/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

// Helper struct for interacting with PF objects
struct NudgeHelper {

    /* Get current PFUser */
    static func getCurrentUser() -> PFUser?
    {
        return PFUser.current()
    }
    
    /* Get current PFUser's group */
    static func getCurrentUserGroup() -> TaskGroup?
    {
        let currentUser = getCurrentUser()
        
        //If user is not in a group, return nothing
        if(currentUser?["groupId"] == nil)
        {
            return nil
        }
        
        //Else get groupId and return the taskGroup associated with the groupId
        let currentUserGroupId = currentUser?["groupId"] as! String
        var taskGroup = TaskGroup()
        
        let userQuery = PFQuery(className: "TaskGroup")
        
        do {
            userQuery.includeKey("tasks")
            let groupObject = try userQuery.getObjectWithId(currentUserGroupId)
            taskGroup = groupObject as! TaskGroup
            print("loaded current user group name: " + taskGroup.name!)
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        return taskGroup
    }
    
    /* Return PFUser by name */
    static func getPFObjectByUsername(username: String) -> [PFObject]?
    {
        //Returns an array but there should only one unique user
        do {
            let userQuery = PFUser.query()
            userQuery?.whereKey("username", equalTo: username)
            let result = try userQuery?.findObjects()
            return result
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    /* set a PFUser to a group */
    static func setUserGroupByUserName(username: String, taskGroup: TaskGroup)
    {
        // TODO: do push then request approval from the other user to add group
        /*
        let pfObject = getPFObjectByUsername(username: username)
        let pfUserObject = pfObject?[0]
        
        do {
            pfUserObject?["groupId"] = taskGroup.objectId
            try pfUserObject?.save()
        }
        catch let error {
            print(error.localizedDescription)
        }*/
    }
    
    /* Get current user group and adds a task to the group's task array */
    static func addTaskToCurrentUserGroup(task: Task)
    {
        let currentUserGroup = getCurrentUserGroup()
        
        if(currentUserGroup != nil)
        {
            if(currentUserGroup!.tasks == nil)
            {
                currentUserGroup!.tasks = [Task]()
            }
            //add task into task array for currentUserGroup
            currentUserGroup!.tasks?.append(task)
            trySaveGroup(taskGroup: currentUserGroup!)
        }
    }
    
    /* Set group made as the current user's group and save to Parse */
    static func setCurrentUserGroup(taskGroup: TaskGroup)
    {
        let currentUser = getCurrentUser()
        
        do {
            currentUser?["groupId"] = taskGroup.objectId
            try currentUser?.save()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    /* Check to see that there are no duplicate group names */
    static func doesGroupNameExist(groupName: String) -> Bool
    {
        //Search through query to see if group name is previously exists
        let userQuery = PFQuery(className: "TaskGroup")
        var doesExist = false
        
        do {
            userQuery.whereKey("name", contains: groupName)
            
            let results = try userQuery.findObjects()
            
            if(results.count == 0)
            {
                doesExist = false
            }
            else
            {
                doesExist = true
            }
        }catch let error {
            print(error.localizedDescription)
        }
        
        return doesExist
    }
    
    /* Save taskGroup into Parse */
    static func trySaveGroup(taskGroup: TaskGroup)
    {
        do {
            try taskGroup.save()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    /* Save task into Parse */
    static func trySaveTask(task: Task)
    {
        do {
            try task.save()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
}
