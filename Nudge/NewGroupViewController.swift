//
//  NewGroupViewController.swift
//  Nudge
//
//  Created by Thuan Nguyen on 4/22/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class NewGroupViewController: UIViewController {

    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var addMemberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Create a taskGroup */
    @IBAction func onCreate(_ sender: Any) {
        let taskGroup = TaskGroup()
        
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
    }

    /* Add member to the taskGroup */
    @IBAction func onAddMember(_ sender: Any) {
        let memberUsername = addMemberTextField.text
        let member = NudgeHelper.getPFObjectByUsername(username: memberUsername!)
        
        if(member != nil && (member?.count)! > 0)
        {
            //Member exists
            NudgeHelper.setUserGroupByUserName(username: memberUsername!, taskGroup: NudgeHelper.getCurrentUserGroup()!)
        }
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
