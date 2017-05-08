//
//  NewGroupViewController.swift
//  Nudge
//
//  Created by Thuan Nguyen on 4/22/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class NewGroupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!

    var pickerData = [String]()
    var memberData = [String]()
    var selectedMember: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Connect data
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        //Input data into the pickerData
        fetchUserNames()
        
        self.pickerView.reloadAllComponents()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* PickerView */
    //The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //fetchUserNames()
        //print("picker data count is \(pickerData.count)")
        return self.pickerData.count
    }
    
    //The data to return for the row and component(column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected \(self.pickerData[row])")
        
        self.selectedMember = self.memberData[row]
    }
    
    /* Create a taskGroup */
    @IBAction func onCreate(_ sender: Any) {
        let taskGroup = TaskGroup()
        
        //TODO: alert if already in a group
        
        if(!NudgeHelper.doesGroupNameExist(groupName: groupNameTextField.text!)){
            //Create and assign group if name is not taken
            taskGroup.name = groupNameTextField.text!
            NudgeHelper.trySaveGroup(taskGroup: taskGroup)
            NudgeHelper.setCurrentUserGroup(taskGroup: taskGroup)
        }
        else {
            //TODO: Prompt to enter another name
            print("Group name already exists")
        }
        self.dismiss(animated: true, completion: nil)
        self.viewWillAppear(true)
    }

    /* Send invitation to member */
    @IBAction func onAddMembers(_ sender: Any) {
        
        if(self.selectedMember != "")
        {
            //Member exists
            // check if member is already in the group
            // if member is not in group, check if there is already invitation created for that member
            
            //Create invitation
            let invitation = Invitation()
            
            invitation.senderId = NudgeHelper.getCurrentUser()?.objectId
            invitation.senderName = NudgeHelper.getUsername()
            invitation.receipientId = self.selectedMember
            invitation.status = InvitationStatus.created.rawValue
            invitation.groupName = NudgeHelper.getGroupName()
            invitation.message = "\(invitation.senderName!) wants to invite you to \(invitation.groupName!)"
            invitation.groupId = NudgeHelper.getCurrentUserGroup()?.objectId
            invitation.dateCreated = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
            NudgeHelper.trySaveInvitation(invitation: invitation)
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /* Choose member to add using pickerView */
    func fetchUserNames(){
        let query = PFQuery(className: "_User")
        
        query.findObjectsInBackground (block: { (users: [PFObject]?, error: Error?) in
            if let users = users{
                print("Entered fetchUserNames")
               
                for user in users{
                    let name = user.object(forKey: "fullname") as! String
                    print("name is \(name)")
                    
                    if name != ""
                    {
                    self.memberData.append(user.objectId!)
                    self.pickerData.append(name)
                    self.pickerView.reloadAllComponents()
                    //print("Picker data count: \(self.pickerData.count)")
                    
                    }
                    else{
                        self.pickerData.append("")
                    }
                }
            }
            else{
                print ("ERROR \(error?.localizedDescription)")
            }
        })
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
