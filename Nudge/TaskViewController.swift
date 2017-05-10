//
//  TaskViewController.swift
//  Nudge
//
//  Created by Dephanie Ho on 4/10/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class TaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var pickerData = [String]()
    var memberData = [String]()
    var selectedMember: String = ""

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
            //print(nudge?.groupId)
            
            let alert = UIAlertController(title: "Nudge", message: "DO IT", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: { action in
                self.openedNudge(nudge: nudge!)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /* Check for invitation */
    func loadInvitation() {
        let invitation = NudgeHelper.getCurrentUserInvitation()
        
        if(invitation != nil)
        {
            //print(invitation?.groupId)
            
            let alert = UIAlertController(title: "Invitation", message: invitation?.message!, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Decline", style: UIAlertActionStyle.cancel, handler: { action in
                self.declineInvitation(invitation: invitation!)
            }))
            alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: { action in
                self.acceptInvitation(invitation: invitation!)
                
            }))

            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /* Accept invitation */
    func acceptInvitation(invitation: Invitation) {
        //Set groupId to receipient
        NudgeHelper.setCurrentUserGroupById(taskGroupId: invitation.groupId!)
        
        //Set invitation status to accepted
        invitation.status = InvitationStatus.accepted.rawValue
        NudgeHelper.trySaveInvitation(invitation: invitation)

    }

    /* Decline invitation */
    func declineInvitation(invitation: Invitation) {
        //Set invitation status to declined
        invitation.status = InvitationStatus.declined.rawValue
        NudgeHelper.trySaveInvitation(invitation: invitation)
    }
    
    /* Opened Nudge */
    func openedNudge(nudge: NudgeNotifcation){
        //Set nudge status to true
        nudge.status = true
    }
    
    /* Delete a task by setting it to inactive */
    func deleteTask(task: Task)
    {
        task.isActive = false
        NudgeHelper.trySaveTask(task: task)
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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /* Create a Nudge to send */
    func onNudge()
    {
        //Create nudge
        let nudge = NudgeNotifcation()
        
        nudge.senderId = NudgeHelper.getCurrentUser()?.objectId
        nudge.receipientId = ""
        nudge.status = true
        nudge.groupName = NudgeHelper.getGroupName()
        nudge.groupId = NudgeHelper.getCurrentUserGroup()?.objectId
        NudgeHelper.trySaveNudge(nudge: nudge)
    }
    
    /* Swipe to get Delete and Nudge button */
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        /* Nudge Button */
        let nudge = UITableViewRowAction(style: .normal, title: "Nudge") { action, index in
            let alertView = UIAlertController(
                title: "Select member to nudge",
                message: "\n\n\n\n\n\n\n\n\n",
                preferredStyle: .alert)
            
            let pickerView = UIPickerView(frame:
                CGRect(x: 0, y: 50, width: 260, height: 162))
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            
            self.pickerData = NudgeHelper.getPFUsersByGroupId(pickerData: self.pickerData)
            pickerView.reloadAllComponents()
            
            alertView.view.addSubview(pickerView)
            
            let action = UIAlertAction(title: "NUDGE", style: UIAlertActionStyle.default, handler: { action in
                //NUDGE BASED ON PICKERSELECTED MEMBER
                //self.onNudge()
            })
            
            alertView.addAction(action)
            
            self.present(alertView, animated: true, completion: { _ in
                pickerView.frame.size.width = alertView.view.frame.size.width
                alertView.view.superview?.isUserInteractionEnabled = true
                alertView.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            })
        }
        nudge.backgroundColor = .orange
        
        /* Delete Button */
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let currentUserTasks = self.currentUserGroup?.tasks
            if(currentUserTasks != nil)
            {
                //Filters through the task array on those that are active
                let currentUserActiveTasks = currentUserTasks?.filter {
                    ///////////TODO active only if not past due
                    task in (task.isActive && task.dueDate < Date.init())
                }
                self.confirmDelete(task: (currentUserActiveTasks?[editActionsForRowAt.row])!, forRowAt: editActionsForRowAt)
            }
        }
        delete.backgroundColor = .red
        
        return [delete, nudge]
    }

    /* Dismiss alert when tapped around */
    func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    /* Confirm delete task alert */
    func confirmDelete(task: Task, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to permanently delete Task: \(task.title!)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.deleteTask(task: task)
            self.tableView.reloadData()

        })
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /* PickerView */
    //The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    //The data to return for the row and component(column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedMember = self.pickerData[row]
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
