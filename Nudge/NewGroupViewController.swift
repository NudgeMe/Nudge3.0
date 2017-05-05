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
    
    //func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //myLabel.text = pickerData[row]
    //}
    
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

    /* Add member to the taskGroup */
    @IBAction func onAddMember(_ sender: Any) {
        let memberUsername = ""//addMemberTextField.text
        let member = NudgeHelper.getPFObjectByUsername(username: memberUsername)
        
        if(member != nil && (member?.count)! > 0)
        {
            //Member exists
            NudgeHelper.setUserGroupByUserName(username: memberUsername, taskGroup: NudgeHelper.getCurrentUserGroup()!)
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchUserNames(){
        let query = PFQuery(className: "_User")
        
        query.findObjectsInBackground (block: { (users: [PFObject]?, error: Error?) in
            if let users = users{
                print("Entered fetchUserNames")
               
                for user in users{
                    let name = user.object(forKey: "fullname") as! String
                    print("name is \(name)")
                    
                    if name != ""{
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
