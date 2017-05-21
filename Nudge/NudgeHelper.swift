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
    
    /* Get PFUser name */
    static func getUsername() -> String
    {
        let currentUser = getCurrentUser()
        
        let currentUsername = currentUser?["username"] as! String
        
        return currentUsername
    }
    
    /* Get username by id */
    static func getUsernameById(user: PFObject) -> String
    {
        let currentUser = user
        
        let currentUsername = user["username"] as! String
        
        return currentUsername
    }
    
    /* Get group id by user id */
    static func getGroupIdById(user: PFObject) -> String
    {
        let currentUser = user
        
        let currentgroupId = user["groupId"] as! String
        
        return currentgroupId
    }
    
    /* Get PFUser fullname */
    static func getFullname() -> String
    {
        let currentUser = getCurrentUser()
        
        let fullName = currentUser?["fullname"] as! String
        
        return fullName
    }
    
    /* Get current PFUser's group */
    static func getCurrentUserGroup() -> TaskGroup?
    {
        let currentUser = getCurrentUser()
        
        //If user is not in a group, return nothing
        if(currentUser?["groupId"] as! String == "" || currentUser?["groupId"] == nil)
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

    /* Check if current user has any invitations */
    static func getCurrentUserInvitation() -> Invitation?
    {
        let currentUser = getCurrentUser()
        
        let userQuery = PFQuery(className: "Invitation")
        
        do {
            userQuery.whereKey("receipientId", equalTo: currentUser?.objectId!)
            //Filter invitations to those that are created, neither accepted or declined
            userQuery.whereKey("status", equalTo: InvitationStatus.created.rawValue)
            
            let results = try userQuery.findObjects()
            
            if(results.count > 0)
            {
                return results[0] as? Invitation
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    /* Check if current user has any nudges */
    static func getCurrentUserNudge() -> NudgeNotifcation?
    {
        let currentUser = getCurrentUser()
        
        let userQuery = PFQuery(className: "NudgeNotification")
        
        do{
            userQuery.whereKey("receipientId", equalTo: currentUser?.objectId!)
            //Filter nudges to those that have been unopened
            userQuery.whereKey("status", equalTo: false)
            //let currentUserActiveTasks = currentUserTasks?.filter {
            //status in task.isActive
            //}

            let results = try userQuery.findObjects()
            print("Nudge count: \(results.count)")

            
            if(results.count > 0)
            {
                return results[0] as! NudgeNotifcation
            }
        }
        catch let error{
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func getCurrentUserGroupAsync(completionHandler: @escaping (_ result: TaskGroup?, _ error: Error?) -> ())
    {
        let currentUser = getCurrentUser()
        
        //If user is not in a group, return nothing
        if(currentUser?["groupId"] != nil)
        {
            
            //Else get groupId and return the taskGroup associated with the groupId
            let currentUserGroupId = currentUser?["groupId"] as! String
            var taskGroup = TaskGroup()
            
            let userQuery = PFQuery(className: "TaskGroup")
            
            do {
                userQuery.includeKey("tasks")
                try userQuery.getObjectInBackground(withId: currentUserGroupId) {
                    (groupObject: PFObject?, error: Error?) -> Void in
                    if (error != nil) {
                        taskGroup = groupObject as! TaskGroup
                        print("loaded current user group name: " + taskGroup.name!)
                        completionHandler(taskGroup, error)
                    }
                    else {
                        completionHandler(nil, error)
                    }
                }
            }
            catch let error {
                completionHandler(nil, error)
            }
        }
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
    
    /* Return PFUser by id */
    static func getPFObjectById(id: String) -> [PFObject]?
    {
        //Returns an array but there should only be one unique user
        do {
            let userQuery = PFUser.query()
            userQuery?.whereKey("objectId", equalTo: id)
            let result = try userQuery?.findObjects()
            return result
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        return nil
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
            currentUser?["isInGroup"] = true
            try currentUser?.save()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    /* Remove user from group */
    static func removeCurrentUserGroup(taskGroup: TaskGroup)
    {
        let currentUser = getCurrentUser()
        
        do {
            currentUser?["groupId"] = ""
            currentUser?["isInGroup"] = false
            try currentUser?.save()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    /* Set group made as the current user's group and save to Parse */
    static func setCurrentUserGroupById(taskGroupId: String)
    {
        let currentUser = getCurrentUser()
        
        do {
            currentUser?["groupId"] = taskGroupId
            currentUser?["isInGroup"] = true
            try currentUser?.save()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    /* Get group name */
    static func getGroupName() -> String
    {
        let currentUserGroup = getCurrentUserGroup()
        
        let groupName = currentUserGroup?["name"]
        
        return groupName as! String
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
    
    /* Save invitation into Parse */
    static func trySaveInvitation(invitation: Invitation)
    {
        do {
            try invitation.save()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    /* Save nudge into Parse */
    static func trySaveNudge(nudge: NudgeNotifcation)
    {
        do{
            try nudge.save()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
}
