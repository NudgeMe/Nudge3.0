//
//  AddMemberViewController.swift
//  Nudge
//
//  Created by Lin Zhou on 5/21/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class AddMemberViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerData = [String]()
    var memberData = [String]()
    var selectedMember: String = ""
    var selectedMemberName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Connect data
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        
        //Input data into the pickerData
        fetchUserNames()
        
        self.pickerView.reloadAllComponents()
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
        return self.pickerData.count
    }
    
    //The data to return for the row and component(column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedMember = self.memberData[row]
        self.selectedMemberName = self.pickerData[row]
    }


    @IBAction func onAdd(_ sender: Any) {
        
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
                    //self.declineInvitation(invitation: invitation!)
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
    }
    
    /* Dismiss alert */
    func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    /* Choose member to add using pickerView */
    func fetchUserNames(){
        let currentUser = NudgeHelper.getCurrentUser()
        
        let query = PFQuery(className: "_User")
        
        query.findObjectsInBackground (block: { (users: [PFObject]?, error: Error?) in
            if let users = users{
                
                for user in users{
                    let name = user.object(forKey: "fullname") as! String
                    
                    if(name != "" && name != currentUser!["fullname"] as! String)
                    {
                        self.memberData.append(user.objectId!)
                        self.pickerData.append(name)
                        self.pickerView.reloadAllComponents()
                    }
                }
            }
            else{
                print ("ERROR \(error?.localizedDescription)")
            }
        })
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
