//
//  TaskViewController.swift
//  Nudge
//
//  Created by Dephanie Ho on 4/10/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class TaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var taskCount = 0
    var currentUserGroup: TaskGroup? = nil
//    let color1 = UIColor(red: 0.4882, green: 0.9704, blue: 0.5078, alpha: 0.6)
//    let color2 = UIColor(red: 0.4882, green: 0.9504, blue: 0.5078, alpha: 0.6)
//    let color3 = UIColor(red: 0.4882, green: 0.9304, blue: 0.5078, alpha: 0.6)
    var colors : [UIColor] = [UIColor(red: 0.4882, green: 0.9704, blue: 0.5078, alpha: 0.6),UIColor(red: 0.6882, green: 0.9904, blue: 0.4078, alpha: 0.6),UIColor(red: 0.6882, green: 0.9904, blue: 0.4078, alpha: 0.4),UIColor(red: 0.6882, green: 0.9904, blue: 0.4078, alpha: 0.2)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.reloadData()
        // Do any additional setup after loading the view.
        
        if(currentUserGroup == nil)
        {
            //If user does not belong in a group, check for invitation
            loadInvitation()
        }
        else{
            //If user does belong in a group, check for nudges
            loadNudge()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Check for nudges */
    func loadNudge() {
        let nudge = NudgeHelper.getCurrentUserNudge()
        
        if(nudge != nil)
        {
            print(nudge?.groupId)
            
            //do popup with message
            //openedNudge()
        }
    }
    
    /* Check for invitation */
    func loadInvitation() {
        let invitation = NudgeHelper.getCurrentUserInvitation()
        
        if(invitation != nil)
        {
            print(invitation?.groupId)
            
            let alert = UIAlertController(title: "Invitation", message: invitation?.message!, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            //do popup
            // if accept
            // acceptInvitation()
            // else declineInvitation()
            acceptInvitation(invitation: invitation!)
            NudgeHelper.trySaveInvitation(invitation: invitation!)
        }
    }
    
    /* Accept invitation */
    func acceptInvitation(invitation: Invitation) {
        //Set groupId to receipient
        NudgeHelper.setCurrentUserGroupById(taskGroupId: invitation.groupId!)
        
        //Set invitation status to accepted
        invitation.status = InvitationStatus.accepted.rawValue
    }

    /* Decline invitation */
    func declineInvitation(invitation: Invitation) {
        //Set invitation status to declined
        invitation.status = InvitationStatus.declined.rawValue
    }
    
    /* Opened Nudge */
    func openedNudge(nudge: NudgeNotifcation){
        //Set nudge status to true
        nudge.status = true
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        //Load tasks here
        let currentUserGroup = NudgeHelper.getCurrentUserGroup()
        
        //Check if user has a taskGroup
        if(currentUserGroup != nil)
        {
            self.currentUserGroup = currentUserGroup
            let currentUserTasks = currentUserGroup?.tasks
            
            //Check if tasks exist in the taskGroup, else return an empty cell
            if(currentUserTasks != nil)
            {
                //Filters through the task array on those that are active
                let currentUserActiveTasks = currentUserTasks?.filter {
                    ///////////TODO active only if not past due
                    task in (task.isActive && task.dueDate < Date.init())
                }
                return (currentUserActiveTasks?.count)!
            }
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if(self.currentUserGroup != nil)
        {
            let currentUserTasks = currentUserGroup?.tasks
            
            //Check if tasks exist in the taskGroup, else return an empty cell
            if(currentUserTasks != nil)
            {
                //Filters through the task array on those that are active
                let currentUserActiveTasks = currentUserTasks?.filter {
                    task in task.isActive
                }
                
                if((currentUserActiveTasks?.count)! > 0)
                {
                    //Active tasks exist, display them as onto the cells
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskViewCell", for: indexPath) as! TaskViewCell
                    let allTasks = currentUserActiveTasks?[indexPath.row]
                    
                    cell.task = allTasks
                    if indexPath.row%4 == 0 {
                        cell.backgroundColor = colors[0]
                    }
                    else if indexPath.row%4 == 1{
                        cell.backgroundColor = colors[1]
                    }
                    else if indexPath.row%4 == 2{
                        cell.backgroundColor = colors[2]
                    }
                    else if indexPath.row%4 == 3{
                        cell.backgroundColor = colors[3]
                    }
                    
                    
                    
                    //cell.backgroundColor = colors[indexPath.row]
                    return cell
                }
            }
        }
        return UITableViewCell()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
