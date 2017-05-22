//
//  NewGroupViewController.swift
//  Nudge
//
//  Created by Dephanie Ho on 4/22/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class NewGroupViewController: UIViewController {

    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    

    var selectedMember: String = ""
    var selectedMemberName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
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
            self.viewWillAppear(true)
        }
        else {
        let alert = UIAlertController(title: "Group name taken", message: "Please choose another name", preferredStyle: UIAlertControllerStyle.alert)
        //dismiss alert
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
        }
    }

    /* Send invitation to member
    @IBAction func onAddMembers(_ sender: Any) {
        
        if(self.selectedMember != "")
        {
            //Check if member is already in group
            let member = NudgeHelper.getPFObjectById(id: self.selectedMember)
            //Member is in a group
            if(NudgeHelper.getGroupIdById(user: (member?[0])!) != "")
            {
                let alert = UIAlertController(title: "Woops!", message: "\(self.selectedMemberName) is already in a group", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)

            }
            else{
                //Member is not in a group
                let alert = UIAlertController(title: "Invitation", message: "Are you sure you want to send an invitation to \(self.selectedMemberName)", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                    
                }))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
                    //Create invitation
                    let invitation = Invitation()
                    
                    invitation.senderId = NudgeHelper.getCurrentUser()?.objectId
                    invitation.senderName = NudgeHelper.getUsername()
                    invitation.senderFullName = NudgeHelper.getFullname()
                    invitation.receipientId = self.selectedMember
                    invitation.status = InvitationStatus.created.rawValue
                    invitation.groupName = NudgeHelper.getGroupName()
                    invitation.message = "(\(invitation.senderFullName!)) \(invitation.senderName!) wants to invite you to \(invitation.groupName!)"
                    invitation.groupId = NudgeHelper.getCurrentUserGroup()?.objectId
                    invitation.dateCreated = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
                    NudgeHelper.trySaveInvitation(invitation: invitation)
                    
                    let sent = UIAlertController(title: "Invitation sent", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    
                    //dismiss alert
                    self.present(sent, animated: true, completion:{
                        sent.view.superview?.isUserInteractionEnabled = true
                        sent.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
                    })
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }*/
    
    /* Dismiss alert */
    func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
